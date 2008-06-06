Return-Path: <linux-kernel-owner+w=401wt.eu-S1764535AbYFFIXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764535AbYFFIXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYFFIXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:23:37 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:37322 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752011AbYFFIXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:23:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Og08UNB6k9Tni4VIe1BhOzQ+rZHKwIALaDLJ21uqwbcRi+btmeavHONla2bFce+JgtTk/xLJjqT+1eYhv/Yw6zpRDTAoqOpoUyS1aew7/ABsOYlp20vRyhgOlKNJP0JfQmwjv13vvp7OE8RmKil6cxT9aWrsXyPLZ0zwzlZkKMs=  ;
X-YMail-OSG: 6ufPIz4VM1lhjNwxk1_vTOPixjmDXL4n7Apw6l_kloOsI.eeQFL7HTYrDCqPCQF69UZ75wsp.riXYLIOCJ02T.4APjFeL9d2MZGWfjdgMib3y_Eyg56t2ZGfm98imI8LS47dR1s6KxfxdfStFK2YxQyE
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Solofo.Ramangalahy@bull.net
Subject: Re: [RFC -mm 0/6] sysv ipc: scale msgmnb with the number of cpus
Date: Fri, 6 Jun 2008 18:23:22 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20080606060955.317871352@bull.net>
In-Reply-To: <20080606060955.317871352@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806061823.22639.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 June 2008 16:09, Solofo.Ramangalahy@bull.net wrote:
> The size in bytes of a SysV IPC message queue, msgmnb, is too small
> for large machines, but we don't want to bloat small machines

What's your evidence for this? Can you provide before / after
performance numbers?

Also, when scaling things like this, it is probably more usual
to use a log scale rather than linear, so that's a thought.

>
> Several methods are used already to modify (mainly increase) msgmnb:
> . distribution specific patch
> . system wide sysctl.conf
> . application specific tuning via /proc/sys/kernel/msgmnb
>
> Integrating this series would:
> . reflect hardware and software evolutions and diversity,
> . reduce configuration/tuning for the applications.
>
> Here is the timeline of the evolution of MSG* #defines:
> Year             1994         1999         1999          2008
> Version           1.0       2.3.27       2.3.30        2.6.24
> #define MSGMNI    128          128           16            16
> #define MSGMAX   4056         8192         8192          8192
> #define MSGMNB  16384        16384        16384         16384
>
> This patch series scales msgmnb, with respect to the number of
> cpus/cores for larger machines. For uniprocessor machines the value
> does not increase.
>
> This series is similar to (and depends on) the series which scales
> msgmni, the number of IPC message queue identifiers, to the amount of
> low memory.
> While Nadia's previous series scaled msgmni along the memory axis,
> hence the message pool (msgmni x msgmnb), this series uses a second
> axis: the number of online CPUs.
> As well as covering the (cpu,memory) space of machines size, this
> reflects the parallelism allowed by lockless send/receive for
> in-flight messages in queues (msgmnb / msgmax messages).
>
> The initial scaling is done at initialization of the ipc namespace.
> Furthermore, the value becomes dynamic with respect to cpu hotplug.
>
> The msgmni and msgmnb values become dependent, as the value of msgmni
> is computed with respect to the value of msgmnb.
>
> The series is as follows:
> . patch 1 introduces the scaling function
> . patch 2 deals with cpu hotplug
> . patch 3 allows user space to disable the scaling mechanism
> . patch 4 allows user space to reenable the scaling mechanism
> . patch 5 finer grain disabling/reenabling scaling mechanism
>           (disconnect msgmnb and msgmni)
> . patch 6 adds documentation
>
> ---
>
> The series applies to 2.6.26-rc2-mm1 + patch suppressing KERN_INFO
> messages as discussed at:
> http://article.gmane.org/gmane.linux.kernel/686229
> "[PATCH 1/1] Only output msgmni value at boot time"
> (in mmotm: ipc-only-output-msgmni-value-at-boot-time.patch)
>
> The plan would be to have this ready for the 2.6.27 merge window if
> there are no objections.
>
>  Documentation/sysctl/kernel.txt |   27 ++++++++++++++++++++++
>  include/linux/ipc_namespace.h   |    4 ++-
>  include/linux/msg.h             |    5 ++++
>  ipc/ipc_sysctl.c                |   48
> ++++++++++++++++++++++++++++++---------- ipc/ipcns_notifier.c            | 
>  23 +++++++------------
>  ipc/msg.c                       |   25 +++++++++++++++++---
>  ipc/util.c                      |   28 +++++++++++++++++++++++
>  ipc/util.h                      |    1
>  8 files changed, 131 insertions(+), 30 deletions(-)
