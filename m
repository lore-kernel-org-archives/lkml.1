Return-Path: <linux-kernel-owner+w=401wt.eu-S1422916AbXDXSE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422916AbXDXSE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422940AbXDXSEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:04:55 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:27299 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422916AbXDXSEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:04:55 -0400
Message-ID: <462E469F.6060502@xensource.com>
Date: Tue, 24 Apr 2007 11:04:15 -0700
From: Jeremy Fitzhardinge <jeremy@xensource.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: LAPLACE Cyprien <cyprien.laplace@trango-systems.com>
CC: virtualization@lists.linux-foundation.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SMP lockup in virtualized environment
References: <462E4223.1050109@trango-systems.com>
In-Reply-To: <462E4223.1050109@trango-systems.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2007 18:04:54.0284 (UTC) FILETIME=[0F953CC0:01C7869B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

LAPLACE Cyprien wrote:
> I wonder how the guest domain can be denied timer interrupts for such a
> long time ? The only reason I see is that the guest domain is not
> scheduled at all (host domain or another higher priority guest running).
>
> Now in SMP host and guest, what happens if a guest CPU is not scheduled
> for a while ?
>   

I think this mostly happens when you're doing an inherently
time-stealing thing, like pausing vcpus or suspend/resume.  But I guess
it could happen with a low-prio domain/vcpu on a busy system.

> An example: in kernel/pid.c:alloc_pid(), if one of the guest CPUs is
> descheduled when holding the pidmap_lock, what happens to the other
> guest CPUs who want to alloc/free pids ? Are they blocked too ?
>   

Yep; its a problem.  If a vcpu holding locks and not running, then
everyone else will be prevented from taking those locks.  If you have a
very busy system, then presumably all the vcpus will be similarly loaded
and the fact that it takes a long time to get locks just means you're
trying to run too many vcpus for your hardware's capacity.

The other problem is if you've got two vcpus sharing one real cpu, and
vcpu A spins while waiting for vcpu B to release a lock, and vcpu B is
waiting for A to get off the physical CPU.  I don't know how often this
is a real problem in practice.

    J

