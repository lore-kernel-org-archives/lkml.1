Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZHNE0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZHNE0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 00:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbZHNE0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 00:26:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:33275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbZHNE0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 00:26:43 -0400
Message-ID: <4A84E766.3070904@kernel.org>
Date: Fri, 14 Aug 2009 13:26:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 2/2 2.6.31-rc5 REPOST] percpu, sparc64: fix sparse possible
 cpu map handling
References: <20090806115705.GB10734@elte.hu>	<4A7B01B8.8000902@kernel.org>	<4A825CD5.3060209@kernel.org> <20090812.162517.13032565.davem@davemloft.net>
In-Reply-To: <20090812.162517.13032565.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 14 Aug 2009 04:26:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Tejun Heo <tj@kernel.org>
> Date: Wed, 12 Aug 2009 15:10:29 +0900
> 
>> Tejun Heo wrote:
>>> Ingo Molnar wrote:
>>>> for the x86 bits:
>>>>
>>>>  Acked-by: Ingo Molnar <mingo@elte.hu>
>>>>
>>>> Once Dave acks it i suspect you can send it to Linus directly?
>> Aieeeee, no response.
> 
> These patches look fine, and I've tested them also on my
> Niagara-2 box.
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> 
> Sorry for the delay :)

Great.  Oops, last review pass revealed a bug in the following chunk.

@@ -1259,9 +1259,16 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 	}

 	/* return the leftover and copy */
-	for_each_possible_cpu(cpu) {
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
 		void *ptr = pcpue_ptr + cpu * pcpue_unit_size;

+		if (cpu_possible(cpu)) {
+			free_bootmem(__pa(ptr + pcpue_size),
+				     pcpue_unit_size - pcpue_size);
+			memcpy(ptr, __per_cpu_load, static_size);
+		} else
+			free_bootmem(__pa(ptr), pcpue_unit_size);
+
 		free_bootmem(__pa(ptr + pcpue_size),
 			     pcpue_unit_size - pcpue_size);
 		memcpy(ptr, __per_cpu_load, static_size);

The if-else block should replace the original free_bootmem()/memcpy()
not added in front of it.  Fixed.  Will reply with updated patch.

Thanks.

-- 
tejun
