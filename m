Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZHMRJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZHMRJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZHMRJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:09:06 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:46355 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZHMRJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:09:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RRJLpuyMl8JKoCEkpEXEcFhBqykbtkWsG29Ry1NmBrfMmrivv2qlabM56bySqk/KgE
         8RdmOrjTEyINlSQtlVCxIUJ7cIwfwpZ6Wp+8B8h71+eLDIjzHK1iYuQwmBm5nfZ3MlYc
         LfuSeMLwLKQpVV6ttZpIHycicEdrJNKsEGXkU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0908121820410.3257@gentwo.org>
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>
	 <alpine.DEB.1.10.0908111032110.30494@gentwo.org>
	 <c4e36d110908110752x253e30epb00cc71f4683052b@mail.gmail.com>
	 <alpine.DEB.1.10.0908111056550.30494@gentwo.org>
	 <c4e36d110908110832y21fba830ub8804613df571228@mail.gmail.com>
	 <20090811154853.GF2763@sgi.com>
	 <c4e36d110908111410y29b922ceod6871fda2514f6e6@mail.gmail.com>
	 <c4e36d110908121516u504809e9y537e9babfa95df1d@mail.gmail.com>
	 <alpine.DEB.1.10.0908121820410.3257@gentwo.org>
Date: Thu, 13 Aug 2009 19:09:04 +0200
Message-ID: <c4e36d110908131009l78b29bffvb4d41b90f9b83288@mail.gmail.com>
Subject: Re: System freeze on reboot - general protection fault
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/13 Christoph Lameter <cl@linux-foundation.org>:
> On Thu, 13 Aug 2009, Zdenek Kabelac wrote:
>
>> > I've added authors of some recent conntrack commits to Cc: - maybe
>> > they might know?
>>
>> I've tested v2.6.30 - and it's crashing in the same way - so any other
>> starting point where slub has the same detection mechanism and
>> conntrack module should be working reliable ?
>
> Next point is 2.6.29.
>

Ok  - played lengthy game between 2.6.29 which appeared to be ok and 2.6.30

And the winner is: ea781f197d6a835cbb93a0bf88ee1696296ed8aa
netfilter: nf_conntrack: use SLAB_DESTROY_BY_RCU and get rid of call_rcu()

The error is actually being hit by  libvirtd networking rules added
during boot for my kvm usage.
(Which I noticed after some time...  leading my game into wrong
direction ;))....

Here are the some last bisect entries:

git bisect bad 54dc79fe0d895758bdaa1dcf8512d3d21263d105
# bad: [5c0de29d06318ec8f6e3ba0d17d62529dbbdc1e8] netfilter:
nf_conntrack: add generic function to get len of generic policy
git bisect bad 5c0de29d06318ec8f6e3ba0d17d62529dbbdc1e8
# good: [e487eb99cf9381a4f8254fa01747a85818da612b] netlink: add nla_policy_len()
git bisect good e487eb99cf9381a4f8254fa01747a85818da612b
# good: [1f9352ae2253a97b07b34dcf16ffa3b4ca12c558] netfilter:
{ip,ip6,arp}_tables: fix incorrect loop detection
git bisect good 1f9352ae2253a97b07b34dcf16ffa3b4ca12c558
# bad: [2732c4e45bb67006fdc9ae6669be866762711ab5] netfilter:
ctnetlink: allocate right-sized ctnetlink skb
git bisect bad 2732c4e45bb67006fdc9ae6669be866762711ab5


Unfortunately the commit cannot be reverted with current tree - thus I
cannot easily check if it's the only problem.
(warning: too many files (created: 3096 deleted: 1096), skipping
inexact rename detection
Automatic revert failed.  After resolving the conflicts,)

Zdenek
