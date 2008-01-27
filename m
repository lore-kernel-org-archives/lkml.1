Return-Path: <linux-kernel-owner+w=401wt.eu-S1760038AbYA0WSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbYA0WSi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 17:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbYA0WS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 17:18:29 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:54513 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbYA0WS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 17:18:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TVK7AfgQo9Rkb3yMpFwCU/8ZpmvyIIbmO5v4kKefkvuvfhD6mNXiTEeXcg31RmmBInwt+ifO9ouckcaUGIeBSD1QdKO5b4pqbqWGWPL2nDaTnJd/k5sfrQJJlwSidXRiNXUi/z2KQ260TZfhNFmZYRfaSdi1C52/OUN5BBDk3Vg=
Message-ID: <524f69650801271418s16f88928xc58dcbe9f5ede9e4@mail.gmail.com>
Date: Sun, 27 Jan 2008 16:18:26 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Trond Myklebust" <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Cc: "Andi Kleen" <ak@suse.de>, swhiteho@redhat.com, sfrench@samba.org,
       vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <1201456562.7346.13.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080127317.043953000@suse.de>
	 <20080127021714.A223614D2E@wotan.suse.de>
	 <524f69650801270857i6610e736q4189dc6af9b22360@mail.gmail.com>
	 <1201456562.7346.13.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If two seeks overlap, can't you end up with an f_pos value that is
different than what either thread seeked to? or if you have a seek and
a read overlap can't you end up with the read occurring in the midst
of an update of f_pos (which takes more than one instruction on
various architectures), e.g. reading an f_pos, which has only the
lower half of a 64 bit field updated?   I agree that you shouldn't
have seeks racing in parallel but I think it is preferable to get
either the updated f_pos or the earlier f_pos not something 1/2
updated.

On Jan 27, 2008 11:56 AM, Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
>
> On Sun, 2008-01-27 at 10:57 -0600, Steve French wrote:
> > Don't you need to a spinlock/spinunlock(i_lock) or something similar
> > (there isn't a spinlock in the file struct unfortunately) around the
> > reads and writes from f_pos in fs/read_write.c in remote_llseek with
> > your patch since the reads/writes from that field are not necessarily
> > atomic and threads could be racing in seek on the same file struct?
>
> Where does is state in POSIX or SUS that we need to cater to that kind
> of application?
> In any case, the current behaviour of f_pos if two threads are sharing
> the file struct is undefined no matter whether you spinlock or not,
> since there is no special locking around sys_read() or sys_write().
>
> Trond
>



-- 
Thanks,

Steve
