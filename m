Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYA1C6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYA1C6b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 21:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYA1C6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 21:58:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbYA1C6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 21:58:20 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Date: Mon, 28 Jan 2008 03:58:13 +0100
User-Agent: KMail/1.9.6
Cc: Steve French <smfrench@gmail.com>, swhiteho@redhat.com, sfrench@samba.org,
       vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
References: <20080127317.043953000@suse.de> <524f69650801271418s16f88928xc58dcbe9f5ede9e4@mail.gmail.com> <1201475336.7346.37.camel@heimdal.trondhjem.org>
In-Reply-To: <1201475336.7346.37.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801280358.14024.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 00:08:56 Trond Myklebust wrote:
> 
> On Sun, 2008-01-27 at 16:18 -0600, Steve French wrote:
> > If two seeks overlap, can't you end up with an f_pos value that is
> > different than what either thread seeked to? or if you have a seek and
> > a read overlap can't you end up with the read occurring in the midst
> > of an update of f_pos (which takes more than one instruction on
> > various architectures), e.g. reading an f_pos, which has only the
> > lower half of a 64 bit field updated?   I agree that you shouldn't
> > have seeks racing in parallel but I think it is preferable to get
> > either the updated f_pos or the earlier f_pos not something 1/2
> > updated.
> 
> Why? The threads are doing something inherently liable to corrupt data
> anyway. If they can race over the seek, why wouldn't they race over the
> read or write too?
> The race in lseek() should probably be the least of your worries in this
> case.

The problem is that it's not a race in who gets to do its thing first, but a 
parallel reader can actually see a corrupted value from the two independent 
words on 32bit (e.g. during a 4GB). And this could actually completely corrupt 
f_pos when it happens with two racing relative seeks or read/write()s

I would consider that a bug.

Fixes would be either to always take a spinlock to update this (nasty on 
platforms where spinlocks are expensive like P4) or define some architecture
specific way to read/write 64bit values consistently. In theory also some
lazy locking seqlock like mechanism could be used, but that had the disadvantage
of being theoretically starvable.

-Andi
