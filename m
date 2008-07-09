Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYGILKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYGILKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbYGILKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:10:13 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54755 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754318AbYGILKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:10:10 -0400
Date: Wed, 9 Jul 2008 07:09:00 -0400
From: Theodore Tso <tytso@mit.edu>
To: Arjan van de Ven <arjan@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>,
       hch@infradead.org, pavel@suse.cz, t-sato@yk.jp.nec.com,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, mtk.manpages@googlemail.com
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709110900.GI9957@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
	pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
	viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, axboe@kernel.dk,
	mtk.manpages@googlemail.com
References: <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709071346.GS11558@disturbed>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Bloody hell! Doesn't *anyone* understand that a frozen filesystem is
> *clean*? That the process of freezing it ensures all dirty data and
> metadata is written out before the freeze completes? And that once
> frozen, it can't be dirtied until unfrozen?

What do you mean by "it can't be diritied until unfrozen".  What
happens if I have a kernel compilation happening on a filesystem which
I am trying to freeze?   Does

(a) the freeze fail (because the checks equivalent to what happens
when you remount a filesystem read-only happen)?

(b) The process gets a kill -9 when it tries to write a file on the
frozen filesystem?

(c) The process gets a kill -STOP when it tries to write
to a file on the frozen filesystem?  

(d) The process won't fail, but just continue to run, filling the page
cache with dirty pages that can't be written out because the
filesystem is frozen?

If the answer is (b) or (c), and if you don't have a timeout, and the
backup process which has frozen the filesystem tries to write to the
filesystem, hilarity will ensue....

> That's 3 (or is it 4 - maybe 5 now that I think about it) different
> ppl in 24 hours that have made this same broken argument about
> being unable to write back dirty data on a frozen filesystem......

It's not a question of writing back dirty data, it's the fact that you
*can't*, leading to the page cache filling up wirth dirty data,
leading eventually to the OOM killer running --- and since the last
time I tried suggesting that if the process holding the file
descriptor freezing the filesystem, that idea got shot down (I see
it's been suggested again), if that happens, there is going to be no
other recovery path other than the Big Red Button.

      	       	    	       	       	   - Ted
