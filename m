Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbXCNAJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbXCNAJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 20:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbXCNAJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 20:09:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:34974 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbXCNAJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 20:09:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RV7dONiPOR27KtpwJtnyp9nqXZ8eQNdMU8dQFRrAzRpbiYjF8HZymyoqcUU0qFUM4oxZtCctGjByJ1oztQnGoCWv6zHNOu2DGKJtGvygs8kmZcSlbfEkTjeaMVLy+hIEArP7TIGeL6tzsgWoX9/qlLBl6HkAlpu+Etf/v/MWeYc=
Message-ID: <f2b55d220703131709i49c2ff8reca77c9ddb618c3d@mail.gmail.com>
Date: Tue, 13 Mar 2007 17:09:03 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       "David Miller" <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       7eggert@gmx.de, dada1@cosmosbay.com, linux-kernel@vger.kernel.org
Subject: Re: sys_write() racy for multi-threaded append?
In-Reply-To: <f2b55d220703131640p47f441cdk6f213e64eb78f2e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
	 <20070313022430.57503b08@lxorguk.ukuu.org.uk>
	 <f2b55d220703130025l48ea2e8ci15ddf0563cf21bf9@mail.gmail.com>
	 <20070313.004224.41634994.davem@davemloft.net>
	 <f2b55d220703130924h11786d9fh1d87f90bcd1b3d60@mail.gmail.com>
	 <f2b55d220703131059j2b47b3e0s1edae6150929684f@mail.gmail.com>
	 <20070313190949.GA3417@infradead.org>
	 <f2b55d220703131640p47f441cdk6f213e64eb78f2e3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In case anyone cares, this is a snippet of my work-in-progress
read_write.c illustrating how I might handle f_pos.  Can anyone point
me to data showing whether it's worth avoiding the spinlock when the
"struct file" is not shared between threads?  (In my world,
correctness comes before code-bumming as long as the algorithm scales
properly, and there are a fair number of corner cases to think through
-- although one might be able to piggy-back on the logic in
fget_light.)

Cheers,
- Michael

/*
 *  Synchronization of f_pos is not for the purpose of serializing writes
 *  to the same file descriptor from multiple threads.  It is solely to
 *  protect against corruption of the f_pos field leading to a severe
 *  violation of its semantics, such as:
 *      - a user-visible negative value on a file type which POSIX forbids
 *        ever to have a negative offset; or
 *      - an unexpected jump from (say) (2^32 - small) to (2^33 - small),
 *        due to an interrupt between the two 32-bit write instructions
 *        needed to write out an loff_t on some architectures, leading to
 *        a delayed overwrite of half of the f_pos value written by another
 *        thread.  (Applicable to SMP and CONFIG_PREEMPT kernels.)
 *
 *  Three tiers of protection on f_pos may be needed in order to trade off
 *  between performance and least surprise:
 *
 *    1. All f_pos accesses must go through accessors that protect against
 *       problems with atomic 64-bit writes on some platforms.  These
 *       accessors are only atomic with respect to one another.
 *
 *    2. Those few accesses that cannot handle transient negative values of
 *       f_pos must be protected from a race in some llseek implementations
 *       (including generic_file_llseek).  Correct application code should
 *       never encounter this race, and the syscall use cases that are
 *       vulnerable to it are relatively infrequent.  This is a job for an
 *       rwlock, although the sense is inverted (readers need exclusive
 *       access to a "stalled pipeline", while writers only need to be able
 *       to fix things up after the fact in the event of an exception).
 *
 *    3. Applications that cannot handle transient overshoot on f_pos, under
 *       conditions where several threads are writing to the same open file
 *       concurrently and one of them experiences a short write, can be
 *       protected from themselves by an rwsem around vfs_write(v) calls.
 *       (The same applies to multi-threaded reads, mutatis mutandis.)
 *       When CONFIG_WOMBAT (waste of memory, brain, and time -- thanks,
 *       Bodo!) is enabled, this per-struct-file rwsem is taken as necessary.
 */

#define file_pos_local_acquire(file, flags) \
        spin_lock_irqsave(file->f_pos_lock, flags)

#define file_pos_local_release(file, flags) \
        spin_unlock_irqrestore(file->f_pos_lock, flags)

#define file_pos_excl_acquire(file, flags) \
        do {                                                            \
                write_lock_irqsave(file->f_pos_rwlock, flags);          \
                spin_lock(file->f_pos_lock);                            \
        } while (0)

#define file_pos_excl_release(file, flags) \
        do {                                                            \
                spin_unlock(file->f_pos_lock);                          \
                write_unlock_irqrestore(file->f_pos_rwlock, flags);     \
        } while (0)

#define file_pos_nonexcl_acquire(file, flags) \
        do {                                                            \
                read_lock_irqsave(file->f_pos_rwlock, flags);           \
                spin_lock(file->f_pos_lock);                            \
        } while (0)

#define file_pos_nonexcl_release(file, flags) \
        do {                                                            \
                spin_unlock(file->f_pos_lock);                          \
                read_unlock_irqrestore(file->f_pos_rwlock, flags);      \
        } while (0)

/*
 *  Accessors for f_pos (the file descriptor "position" for seekable file
 *  types, also of interest as a bytes read/written counter on non-seekable
 *  file types such as pipes and FIFOs).  The f_pos field of struct file
 *  should be accessed exclusively through these functions, so that the
 *  changes needed to interlock these accesses atomically are localized to
 *  the accessor functions.
 *
 *  file_pos_write is defined to return the old file position so that it
 *  can be restored by the caller if appropriate.  (Note that it is not
 *  necessarily guaranteed that restoring the old position will not clobber
 *  a value written by another thread; see below.)  file_pos_adjust is also
 *  defined to return the old file position because it is more often needed
 *  immediately by the caller; the new position can always be obtained by
 *  adding the value passed into the "pos" parameter to file_pos_adjust.
 */

/*
 *  Architectures on which an aligned 64-bit read/write is atomic can omit
 *  locking in file_pos_read and file_pos_write, but not in file_pos_adjust.
 *  Not locking in file_pos_write could lead to a "lost seek" from another
 *  thread between the old position (returned by file_pos_write) and the new
 *  position; any use of the value returned by file_pos_write must take this
 *  into account.
 */
static inline loff_t file_pos_read(const struct file *file)
{
        loff_t oldpos;
        unsigned long flags;

        file_pos_local_acquire(file, flags);
        oldpos = file->f_pos;
        file_pos_local_release(file, flags);
        return oldpos;
}

static inline loff_t file_pos_write(struct file *file, loff_t pos)
{
        loff_t oldpos;
        unsigned long flags;

        file_pos_local_acquire(file, flags);
        oldpos = file->f_pos;
        file->f_pos = pos;
        file_pos_local_release(file, flags);
        return oldpos;
}

/*
 *  file_pos_adjust is logically a read-modify-write and could be replaced
 *  by an atomic 64-bit read-modify-write operation on an architecture where
 *  this is available.  Such an architecture would not need f_pos_lock.
 */
static inline loff_t file_pos_adjust(struct file *file, loff_t offset)
{
        loff_t oldpos;
        unsigned long flags;

        file_pos_local_acquire(file, flags);
        oldpos = file->f_pos;
        file->f_pos = oldpos + offset;
        file_pos_local_release(file, flags);
        return oldpos;
}

/*
 *  file_pos_raw_write and file_pos_raw_adjust are to be called only while
 *  the caller is already holding f_pos_lock.
 */
static inline loff_t file_pos_raw_adjust(struct file *file, loff_t offset)
{
        loff_t oldpos;
        oldpos = file->f_pos;
        file->f_pos = oldpos + offset;
        return oldpos;
}

/*
 *  file_pos_read_safe differs in principle from file_pos_read in that
 *  it should never return a "transient" value (negative due to the race
 *  in llseek or too large due to the overshoot in read/write).  Use it
 *  only when the caller needs an accurate position in a multi-threaded
 *  scenario; it effectively forces a pipeline flush.
 */
static inline loff_t file_pos_read_safe(struct file *file)
{
        loff_t pos;
        unsigned long flags;

        file_pos_excl_acquire(file, flags);
        pos = file->f_pos;
        file_pos_excl_release(file, flags);
        return pos;
}

/*
 *  In the common case (seek to a valid file offset), generic_file_llseek
 *  touches the f_pos member with exactly one accessor (file_pos_write or
 *  file_pos_adjust).  It does not perform a check against s_maxbytes,
 *  because POSIX 2004 doesn't require such a check (EINVAL is supposed to
 *  indicate a bad "whence" argument or an attempt to seek to a negative
 *  offset).  Filesystems are required to verify the reasonableness of the
 *  "pos" argument to all read/write calls, which is not checked by syscall
 *  wrappers such as sys_pwrite.
 *
 *  This implementation contains a race condition which could lead to a
 *  transiently negative value of f_pos being visible to another thread
 *  during an llseek with SEEK_CUR to an invalid offset.  POSIX requires that
 *  "the file offset shall remain unchanged" on error, but doesn't address
 *  atomicity issues when two threads write/seek concurrently on the same
 *  file descriptor.
 *
 *  This function does not check whether the file is a pipe/FIFO/socket and
 *  therefore "incapable of seeking" according to POSIX!  Callers who
 *  require strict POSIX semantics (such as sys_lseek()) must do their own
 *  checks for EBADF, ESPIPE, and EOVERFLOW.  This function does, however,
 *  handle all EINVAL cases according to the POSIX semantics of "a regular
 *  file, block special file, or directory".  It is therefore not suitable
 *  for hypothetical devices for which a negative file offset may be valid.
 */

loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
{
        /* Catch all invalid values of "origin" in one test. */
        if (unlikely(((unsigned int)origin) > SEEK_END))
                return -EINVAL;

        if (origin != SEEK_CUR) {
                /* Seeking to an absolute position is the simple case. */
                loff_t oldpos;
                /*
                 * When generic_file_llseek needs the inode in order to
                 * retrieve the current file size, it goes through f_mapping
                 * (the pagecache entry) rather than through f_path.dentry
                 * (the dentry cache).  All other inode retrievals in
                 * read_write.c go through f_path.dentry.  Why?
                 */
                if (origin == SEEK_END)
                        offset += i_size_read(file->f_mapping->host);
                if (unlikely(offset < 0))
                        return -EINVAL;
                oldpos = file_pos_write(file, offset);
                if (likely(oldpos != offset))
                        file->f_version = 0;
                return offset;
        } else if (unlikely(offset == 0)) {
                /* llseek(fd, 0, SEEK_CUR) is asking to read f_pos.  Use
                 * file_pos_read_safe to avoid returning a transient value. */
                return file_pos_read_safe(file);
        } else {
                loff_t oldpos, retval;
                unsigned long flags;

                file_pos_nonexcl_acquire(file, flags);
                oldpos = file_pos_raw_adjust(file, offset);
                if (unlikely(oldpos + offset < 0)) {
                        /* !!! TRANSIENTLY NEGATIVE f_pos !!! */
                        /*
                         * Several relative seeks could have raced here.
                         * We want to leave f_pos with a non-negative value,
                         * while obeying POSIX in spirit (no change to f_pos
                         * on EINVAL).  But we don't want to require an
                         * atomic read-modify-write that's conditional on the
                         * result of the arithmetic -- at least not on
                         * architectures that lack LL/SC.  So we do something
                         * reasonable: leave a positive value in f_pos that
                         * was the actual file offset before one of the
                         * relative seeks.
                         */
                        if (oldpos >= 0)
                                file_pos_raw_write(file, oldpos);
                        retval = -EINVAL;
                } else {
                        file->f_version = 0;
                        retval = oldpos + offset;
                }
                file_pos_nonexcl_release(file, flags);
                return retval;
        }
        /* Control should never reach the end of this function */
}
