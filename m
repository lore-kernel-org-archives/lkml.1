Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbZDNVHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbZDNVHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbZDNVHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:07:40 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:36828 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbZDNVHh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:07:37 -0400
Message-ID: <49E4FB0C.1080103@cosmosbay.com>
Date: Tue, 14 Apr 2009 23:07:24 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Eric Leblond <eric@inl.fr>
CC: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Patrick McHardy <kaber@trash.net>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: [PATCH] netfilter: nf_log fix
References: <20090410191736.21efab8c@mako-desktop>	 <49E4744D.5090205@trash.net>	<49E47C2D.1050508@cosmosbay.com>	 <49E47EA5.3060706@trash.net> <20090414211946.4ea0455e@mako-desktop>	 <49E4EE9C.7040509@cosmosbay.com> <1239742000.24204.9.camel@ice-age>
In-Reply-To: <1239742000.24204.9.camel@ice-age>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 14 Apr 2009 23:07:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Leblond a écrit :
> Hi,
> 
> Le mardi 14 avril 2009 à 22:14 +0200, Eric Dumazet a écrit :
>> Mariusz Kozlowski a écrit :
>>> On Tue, 14 Apr 2009 14:16:37 +0200
>>> Patrick McHardy <kaber@trash.net> wrote:
>>>
>>>> Eric Dumazet wrote:
>>>>> Patrick McHardy a écrit :
>>>>>> Mariusz Kozlowski wrote:
>>>>>>>     netfilter: nf_conntrack: use SLAB_DESTROY_BY_RCU and get rid of
>>>>>>> call_rcu()
>>>>>> Thanks for the report. Does this patch fix it?
>>>>>>
>>>>> Hi Patrick, sorry for the delay, I was in holidays.
>>>> No problem, me too :)
>>>>
> ...
> 
>> Check commit ca735b3aaa945626ba65a3e51145bfe4ecd9e222
>>
>> netfilter: use a linked list of loggers
> 
> ...
> 
>> Signed-off-by: Eric Leblond <eric@inl.fr>
>> Signed-off-by: Patrick McHardy <kaber@trash.net>
>>
>> It seems "struct list_head        list[NFPROTO_NUMPROTO];" is not initialized in "struct nf_logger" ?
>>
>> Please try following patch ?
> 
> I've just tested your patch. Without it, I was able to trigger the bug
> (modprobe ebt_ulog ; rmmod ebt_ulog). All run cleanly with it.
> 

OK thanks everybody, I submit it more formally then, using ARRAY_SIZE() macro too :)

[PATCH] netfilter: nf_log fix

commit ca735b3aaa945626ba65a3e51145bfe4ecd9e222
'netfilter: use a linked list of loggers'
introduced an array of list_head in "struct nf_logger", but
forgot to initialize it in nf_log_register(). This resulted
in oops when calling nf_log_unregister() at module unload time.

Reported-and-tested-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Eric Leblond <eric@inl.fr>

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 8bb998f..d8b85ab 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -36,10 +36,14 @@ static struct nf_logger *__find_logger(int pf, const char *str_logger)
 int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 {
 	const struct nf_logger *llog;
+	int i;
 
 	if (pf >= ARRAY_SIZE(nf_loggers))
 		return -EINVAL;
 
+	for (i = 0; i < ARRAY_SIZE(logger->list); i++)
+		INIT_LIST_HEAD(&logger->list[i]);
+
 	mutex_lock(&nf_log_mutex);
 
 	if (pf == NFPROTO_UNSPEC) {

