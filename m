Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZG1MrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZG1MrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 08:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZG1MrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 08:47:14 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:57531 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbZG1MrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 08:47:13 -0400
Message-ID: <4A6EF33E.6080408@gmail.com>
Date: Tue, 28 Jul 2009 14:46:54 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, herbert@gondor.apana.org.au,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [Bug #13838] kernel BUG at include/net/netns/generic.h:41!
References: <Jya1GruKQpD.A.16.2GObKB@chimera>	 <3zAHs5O6maO.A.B5B.IHObKB@chimera>	 <2375c9f90907262229t2def934emb9340c31d3efdc21@mail.gmail.com> <68676e00907280130tbbf5672x83182641b0c977b3@mail.gmail.com>
In-Reply-To: <68676e00907280130tbbf5672x83182641b0c977b3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 28 Jul 2009 14:46:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti a écrit :
> On Mon, Jul 27, 2009 at 7:29 AM, Américo Wang<xiyou.wangcong@gmail.com> wrote:
>> On Mon, Jul 27, 2009 at 4:28 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.30.  Please verify if it still should be listed and let me know
>>> (either way).
>>>
>>>
>>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13838
>>> Subject         : kernel BUG at include/net/netns/generic.h:41!
>>> Submitter       : Luca Tettamanti <kronos.it@gmail.com>
>>> Date            : 2009-07-20 15:27 (7 days old)
>>> References      : http://lkml.org/lkml/2009/7/20/105
>> Hmm, it looks like that 'pfkey_net_id' is still zero after ipsec_pfkey_init()...
>>
>> Add Herbert and net-dev into Cc.
>>
>> Luca, would you mind to provide your .config and the steps to reproduce this?
> 
> I cannot reproduce it anymore with the current git kernel. The BUG was
> triggered by racoon at startup.
> Should I go back to an older kernel to investigate or can we consider
> it "fixed"?
> 

This should be fixed by following patch (submitted for bug 13760, but should apply)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index b7292a2..1972830 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -488,7 +488,7 @@ int net_assign_generic(struct net *net, int id, void *data)
 	 */
 
 	ng->len = id;
-	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len);
+	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len * sizeof(void *));
 
 	rcu_assign_pointer(net->gen, ng);
 	call_rcu(&old_ng->rcu, net_generic_release);
