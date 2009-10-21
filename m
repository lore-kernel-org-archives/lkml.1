Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbZJUWH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbZJUWH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 18:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZJUWH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 18:07:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbZJUWHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 18:07:25 -0400
Date: Thu, 22 Oct 2009 00:06:32 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Arnd Bergmann <arndbergmann@googlemail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
In-Reply-To: <20091021215553.GE4880@nowhere>
Message-ID: <alpine.LFD.2.00.0910220001470.3526@localhost.localdomain>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <alpine.LFD.2.00.0910192019420.3563@localhost.localdomain> <200910200000.24574.arnd@arndb.de> <200910200008.57468.arnd@arndb.de> <20091021213139.GC4880@nowhere>
 <alpine.LFD.2.00.0910212336290.3526@localhost.localdomain> <20091021215553.GE4880@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Oct 2009, Frederic Weisbecker wrote:

> On Wed, Oct 21, 2009 at 11:41:07PM +0200, John Kacur wrote:
> > > What about a pusdown of default_lseek attribution for these
> > > fops that don't have any llseek() (and rename it to
> > > deprecated_default_lseek() )
> > > 
> > > Because we can probably fix these fops one by one but what
> > > about the next drivers that will have no llseek() ?
> > > 
> > > We can't attribute default_llseek() by default anymore for
> > > further fops that are to come.
> > > 
> > > 
> > 
> > Frederic, I think it is still useful to explicity set to no_llseek, 
> > drivers that don't use llseek.
> 
> 
> Yeah, I agreed.
> 
> 
>  
> > I also have to agree with you, that we should no longer be using a 
> > default_llseek that relies on the BKL.
> > 
> > That is a rather large effort though. All drivers that don't specify an 
> > llseek function, need to either set it to no_llseek, or as you are 
> > proposing a deprecated default_llseek that uses the bkl.
> > 
> > thinking of how to start this.
> > 
> > John
> 
> 
> This is a rather large effort indeed but this pushdown seems
> the only way to remove default_llseek as the default llseek()
> callback.
> 
> The more we wait, the more code we'll need to review and fix.
> 

Okay, I'm sure there is something wrong in this methodology, but it's late 
at night. At least for a ballpark figure, hopefully it's right.

Files that mentions "file_operations" - 
Files that mention "file_operations" and mention "llseek"
= 1172 - 596 = 572 (in my particular git repo)

So, over 550 files that need to be set to no_llseek, locked_llseek, or 
unlocked_llseek. Yikes!

[jkacur@tycho rt.linux.git]$ git-grep -l file_operations | grep -v 
Documentation | wc -l
1172
[jkacur@tycho rt.linux.git]$ git-grep -l llseek $(git-grep -l 
file_operations | grep -v Documentation) | wc -l
596

