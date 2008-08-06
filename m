Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbYHFVwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbYHFVwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYHFVvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:51:51 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:60417 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYHFVvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:51:49 -0400
Date: Wed, 6 Aug 2008 23:51:34 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: "Rafael C. de Almeida" <almeidaraf@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Weird behaviour on /proc/stat
In-Reply-To: <489A0B27.80604@gmail.com>
Message-ID: <alpine.LNX.1.10.0808062318460.5671@titan.stealer.net>
References: <489A0B27.80604@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -1.0
X-Spam-Bar: -
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Wed, 06 Aug 2008 21:51:48 +0000
	Bayes: 0.0443 Tokens: new, 251; hammy, 3; neutral, 8; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0443]
X-Spam-Signature: b2a1e38b5f5a15377862548c0cfab93297c1acb2
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Rafael C. de Almeida wrote:

> I've executed the following code on a intel core 2 quad (linux 2.6.21.5):
> 
> for (( x=0; x < 1800; x = x+1 )); do
>         head -n5 /proc/stat |
>         awk '{ print $2+$3+$4+$5+$6+$7+$8+$9 }' |
>         awk 'BEGIN { x=0 } { if (NR == 1) y=$0; else x=x+$1; } END {
> print y, x }' |
>         awk '{ print $0, $1-$2 }' >> values
>         sleep 1;
> done
> 
> My expectation was that the values file would have only 0s on the second
> field. It didn't happen. Actually, it was always a value greater than 0.
> So I went to the kernel code. The utilization is summed up here:
> 
> 	http://lxr.linux.no/linux+v2.6.21.5/fs/proc/proc_misc.c#L463
> 
> Reading that file, if anything the sum of all the cpuX fields should be
> greater than the cpu line. After all, it happens later and, if
> information regarding the utilization is updated during the generation
> of the output, then the cpuX lines should have a greater value.
> 
> I also noted that on
> 	http://lxr.linux.no/linux+v2.6.21.5/fs/proc/proc_misc.c#L463
> for_each_possible_cpu is used. While on
> 	http://lxr.linux.no/linux+v2.6.21.5/fs/proc/proc_misc.c#L487
> for_each_online_cpu is used. All the cores on the system are online, so
> where could be the extra utilization that's being added to the first
> line result?
> 
> I wish I had a machine with 4 cores which I could test changes on that
> code, so I could investigate things a little further. But the only
> machine I can change the kernel is my home computer which has only one
> core  :(.

It's expected behaviour, but it is indeed misleading. Here's the reason 
why it happens: In the kernel we're accounting time based on CONFIG_HZ 
(which I suspect is 1000 in your case) but are exporting values based on 
USER_HZ (100, historic reasons) to userspace. So we're effectively 
dividing the values by 10. Well, that division obviously leaves a 
remainder in most cases, which is dropped. You see in the code that for 
the summary we first add all in-kernel values up and then do the 
conversion (cputime64_to_clock_t) to userspace values. So we're actually 
adding up all the remainders, which we drop when converting each per-cpu 
data on its own. This leads to a couple of additional jiffies being 
accounted in the summary.

Sven
