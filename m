Return-Path: <linux-kernel-owner+w=401wt.eu-S934621AbXKPCoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934621AbXKPCoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757662AbXKPCoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:44:11 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:42153 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756435AbXKPCoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:44:09 -0500
Date: Thu, 15 Nov 2007 18:44:08 -0800
From: Micah Dowty <micah@vmware.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071116024408.GA20322@vmware.com>
References: <20071109223417.GB16250@vmware.com> <4734F397.7080802@gmx.net> <20071110001103.GD16250@vmware.com> <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com> <20071115191408.GA4914@vmware.com> <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com> <20071115202425.GC4914@vmware.com> <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com> <20071115213510.GA16079@vmware.com> <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 06:31:49PM -0800, Christoph Lameter wrote:
> On Thu, 15 Nov 2007, Micah Dowty wrote:
> 
> > On all kernels I've tested from after your patch was committed, I can
> > reproduce a problem where a single high-priority thread which wakes up
> > very frequently can artificially inflate the SMP balancer's load
> > average for one CPU, causing other tasks to be migrated off that
> > CPU. The result is that this high-priority thread (which may only use
> > a few percent CPU) gets an entire CPU to itself. Even if there are
> > several busy-looping threads running, this CPU will be mostly idle.
> 
> I am a bit at a loss as to how this could relate to the patch. This looks 
> like a load balance logic issue that causes the load calculation to go 
> wrong?

My best guess is that this has something to do with the timing with
which we sample the CPU's instantaneous load when calculating the load
averages.. but I still understand only the basics of the scheduler and
SMP balancer. All I really know for sure at this point regarding your
patch is that git-bisect found it for me.

It almost seems like the load average algorithm is ignoring the CPU's
idle time, and only accounting for the time that CPU spends running
processes. One of the symptoms is that the mostly-idle CPU in my test
has an instantaneous load which is usually zero, but a very high load
average. (9000, 30000, etc.)

I want to help get to the bottom of this issue, but I was hoping that
someone experienced with the Linux scheduler and SMP balancer would
have some insight or some suggestions about what to try next.

Thanks,
--Micah
