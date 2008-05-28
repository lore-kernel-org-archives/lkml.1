Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbYE1Ppe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbYE1Ppe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 11:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYE1Pp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 11:45:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39547 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbYE1Pp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 11:45:26 -0400
Date: Wed, 28 May 2008 17:45:25 +0200
From: Jan Kara <jack@suse.cz>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Hunter Adrian <ext-Adrian.Hunter@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: UBIFS seekdir()/telldir() issue
Message-ID: <20080528154525.GA32634@atrey.karlin.mff.cuni.cz>
References: <483AC0ED.5060805@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483AC0ED.5060805@nokia.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> The problem
> ~~~~~~~~~~~
> 
> telldir() returns an opaque 32-bit value which should be enough
> to seek to the position later and continue readdir()-ing.
> 
> UBIFS stores direntries in a B-tree with 64-bit keys like:
> | Parent Ino (32-bit) | key type (3 bits) | name hash (29 bits) |
> 
> The name hash may have collisions. Obviously, this does not
> quite fit to the telldir()/seekdir() model.
> 
> Note, this is very similar to reiserfs and reiser4 approach.
> 
> Current UBIFS implementation
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> At the moment UBIFS stores the hash value in file->f_pos, so
> telldir() basically returns direntry name hash values. And this
> does not quite work in case of hash collisions - seekdir() may
> not always seek correctly, which is rare though.
  Yes, this is a classical problem of seekdir implementations :).

> However, consecutive readdir() calls work fine because we store
> full name in file->private_data which helps to deal with
> collisions.
> 
> Naturally, readdir() returns direntries in hash order.
> 
> It seems there are not much applications which depend on telldir()
> and seekdir(), so this does not look too bad, at least in embedded
> world. But this means NFS will not really work because it needs
> "absolute" seekdir() implementation.
> 
> Possible approach
> ~~~~~~~~~~~~~~~~~
> 
> Short investigation showed that other file-systems have separate
> trees which are needed just for the sake of seekdir(). Well, it is
> sad that FSes have to do this just because of not very good
> interface, but such is live.
> 
> In UBIFS we are very reluctant to maintain any additional on-flash
> tree which would emulate traditional Unix "directory is an array
> of direntries" view. It is just too much overhead for embedded
> systems. And it would add more complexity to an already complex
> file-system.
> 
> Instead, we would like to do the following.
> 
> 1. Assign a 32-bit unique id for each direntry. Each directory
> inode has its own space of the ids.
> 2. readdir() stores the id of the next direntry to return in
> file->f_pos, which means telldir() will return the unique ids,
> not hashes as it is currently done.
> 3. However, readdir() still walks direntries in hash, and
> it stores the key and full name of the next entry in
> file->private_data. This makes consecutive readdir() calls
> work correctly and efficiently.
> 4. When seeking, UBIFS havs to scan the main B-tree and
> look up direntry with the required ID. This is not efficient.
> 
> This approach gives full seekdir() support, except of one case
> described below.
> 
> Problems with this approach would be:
> 1. Slow seeks. But we think that actually rare applications do
> seekdir(), at least in embedded world. Comments?
> 
> 2. If the direntry we are trying to seek to was _deleted_, we'll be
> unable to gracefully start from the closest next one. This is simply
> because readdir() returns entries in hash order, not in id order.
> The best UBIFS would be able to do in this case is to seek to the
> beginning of the directory.
> 
> IOW, sequence like this would be problematic:
> 
> dir = opendir();
> pos = telldir(dir);
> dent = readdri(dir);
> unlink(dent->d_name);
> closedir(dir);
> dir = opendir();
> seekdir(pos); // Here we do not know where to seek
> 
> But we think this is also quite rare use-case and it should not
> hurt to seek to the beginning in these cases. Comments?
  The sequence you write above is actually incorrect I think. Noone
guarantees that the cookie returned by telldir() is valid after
closedir(). What is a bigger (and quite common) problem is, if somebody
uses readdir/telldir/seekdir while someone else creates/deletes files in
the directory. The standard implies in this case that subsequent
readdir should return all the files which were not touched (or all files
after position set by seekdir if used...).


									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
