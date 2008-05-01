Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbYEAWJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbYEAWJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762958AbYEAWJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:09:07 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48237 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbYEAWJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:09:05 -0400
Subject: Re: [PATCH] jbd_commit_transaction() races with
	journal_try_to_drop_buffers() causing DIO failures
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1209654981.27240.19.camel@badari-desktop>
References: <20080306174209.GA14193@duck.suse.cz>
	 <1209166706.6040.20.camel@localhost.localdomain>
	 <20080428122626.GC17054@duck.suse.cz>
	 <1209402694.23575.5.camel@badari-desktop>
	 <20080428180932.GI17054@duck.suse.cz>
	 <1209409764.11872.6.camel@localhost.localdomain>
	 <20080429124321.GD1987@duck.suse.cz>
	 <1209654981.27240.19.camel@badari-desktop>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Thu, 01 May 2008 15:08:56 -0700
Message-Id: <1209679736.3693.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 08:16 -0700, Badari Pulavarty wrote:
> Hi Andrew & Jan,
> 
> I was able to reproduce the customer problem involving DIO
> (invalidate_inode_pages2) problem by writing simple testcase
> to keep writing to a file using buffered writes and DIO writes
> forever in a loop. I see DIO writes fail with -EIO.
> 
> After a long debug, found 2 cases how this could happen.
> These are race conditions with 
> and journal_commit_transaction().
> 
> 1) journal_submit_data_buffers() tries to get bh_state lock. If
> try lock fails, it drops the j_list_lock and sleeps for
> bh_state lock, while holding a reference on the buffer.
> In the meanwhile, journal_try_to_free_buffers() can clean up the
> journal head could call try_to_free_buffers(). try_to_free_buffers()
> would fail due to the reference held by journal_submit_data_buffers()
> - which in turn causes failues for DIO (invalidate_inode_pages2()).
> 
> 2) When the buffer is on t_locked_list waiting for IO to finish,
> we hold a reference and give up the cpu, if we can't get
> bh_state lock. This causes try_to_free_buffers() to fail.
> 

Besides these two, I think there are two more race conditions with
journal_try_to_free_buffers() inside
journal_commit_transaction()->journal_submit_data_buffers()

3) when journal_submit_data_buffers() saw the buffer is dirty but failed
to lock the buffer bh1, journal_submit_data_buffers() released the
j_list_lock and submit other buffers collected from previous check, with
the reference to bh1 still hold. During this time
journal_try_to_free_buffers() could clean up the journal head of bh1 and
remove it from the t_syncdata_list. Then try_to_free_buffers() would
fail because the reference held by journal_submit_data_buffers()

...
		if (buffer_dirty(bh)) {
                       if (test_set_buffer_locked(bh)) {
                                BUFFER_TRACE(bh, "needs blocking lock");
                                spin_unlock(&journal->j_list_lock);
					<-- here release the j_list_lock without put(bh)
                                            journal_try_to_free_buffers() could come in and remove this bh from t_syncdata_list

                                /* Write out all data to prevent deadlocks */
                                journal_do_submit_data(wbuf, bufs);
                                bufs = 0;
                                lock_buffer(bh);
                                spin_lock(&journal->j_list_lock);
                                        <-- here continue the check without validate if the bh still on t_sycdata_list

                        }
                        locked = 1;
                }


4) when journal_commit_transaction() go through the t_locked_list and
wait for the buffer to be unlocked, it still holds the reference to the
buffer, released the j_list_lock and gives the
journal_try_to_free_buffers() a chance to come in remove this buffer
from t_locked_list, but journal_commit_transaction() continues as if the
buffer still on the locked list.

      while (commit_transaction->t_locked_list) {
                struct buffer_head *bh;

                jh = commit_transaction->t_locked_list->b_tprev;
                bh = jh2bh(jh);
                get_bh(bh);
                if (buffer_locked(bh)) {
                        spin_unlock(&journal->j_list_lock);
                        wait_on_buffer(bh);
                        if (unlikely(!buffer_uptodate(bh)))
                                err = -EIO;
                        spin_lock(&journal->j_list_lock);
                }

Mingming

