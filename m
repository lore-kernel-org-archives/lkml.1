Return-Path: <linux-kernel-owner+w=401wt.eu-S1763182AbZCQKar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763182AbZCQKar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 06:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbZCQKai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 06:30:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:10782 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbZCQKah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FTsmGqfFAcn+uOED+xbXqh+Q//eyf6B/l4HlBOkyz2fSk4Ku9L/nGlvRXkxkFCktIz
         6aipxKLnikF6tYV9fEYn84TzZ8/hXc5o6gtp/H5tTQgPNVj2n+3YCIik68FYtUEH0X8k
         YRP/aOFSZ4D4gaEgrFZJQZNwumcfok8OBGDhE=
Date: Tue, 17 Mar 2009 13:37:44 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Zhang Le <r0bertz@gentoo.org>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, alan@redhat.com
Subject: Re: [PATCH] filp->f_pos not correctly updated in proc_task_readdir
Message-ID: <20090317103744.GA2399@x200.localdomain>
References: <1237185871-3343-1-git-send-email-r0bertz@gentoo.org> <20090316083457.GV28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316083457.GV28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 08:34:57AM +0000, Al Viro wrote:
> On Mon, Mar 16, 2009 at 02:44:31PM +0800, Zhang Le wrote:
> > filp->f_pos only get updated at the end of the function. Thus d_off of those
> > dirents who are in the middle will be 0, and this will cause a problem in
> > glibc's readdir implementation, specifically endless loop. Because when overflow
> > occurs, f_pos will be set to next dirent to read, however it will be 0, unless
> > the next one is the last one. So it will start over again and again.
> 
> Eh...  Here's what's really going on:
> 
> proc_..._fill_cache() API is rather kludgy and far too convoluted.  In
> particular, it calls filldir() and passes file->f_pos to it, expecting
> the caller to update file->f_pos between the calls.  proc_task_readdir()
> uses that sucker, but doesn't update ->f_pos until the very end.  As
> the result, d_off of direntries produced by it gets screwed.
> Broken-by: commit 61a28784028e6d55755e4d0f39bee8d9bf2ee8d9
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Mon Oct 2 02:18:49 2006 -0700
> 
>     [PATCH] proc: Remove the hard coded inode numbers
> 
> Patch is fine, but I'd rather rip the layers of ..._fill_cache() abstractions
> out and see what falls out.  Anyway, for -rc your variant is definitely the
> way to go.

Except this bit:

fs/built-in.o: In function `proc_task_readdir':
compr_zlib.c:(.text+0x434b8): undefined reference to `__cmpdi2'
compr_zlib.c:(.text+0x434d4): undefined reference to `__cmpdi2'
