Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZBRHXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZBRHXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 02:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbZBRHX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 02:23:28 -0500
Received: from smtp4.tech.numericable.fr ([82.216.111.40]:53175 "EHLO
	smtp4.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZBRHX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 02:23:27 -0500
Message-ID: <499BB76C.1030109@numericable.fr>
Date: Wed, 18 Feb 2009 08:23:24 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: Casey Schaufler <casey@schaufler-ca.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] SMACK netfilter smacklabel socket match
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <fa.3IBoeBnwT1eZcqeO6DAE1tHBYc4@ifi.uio.no> <499B178B.9090601@numericable.fr> <200902171852.21061.paul.moore@hp.com>
In-Reply-To: <200902171852.21061.paul.moore@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore wrote:
> On Tuesday 17 February 2009 03:01:15 pm etienne wrote:
>> I realize this patch is a little ugly, a cleaner way would be to insert 
>> struct smk_netlbladdr sorted from longest to smallest mask and break the
>> loop as soon as we have a match... regards,
> 
> Agreed, the address matching code really should be improved; if you feel like 
> you could contribute the changes I'm pretty sure Casey would welcome the 
> patches :)
> 
yes I could try that, this week-end maybe

> Regarding your fix below, I think a cleaner solution would be to do something 
> like the following in place of the existing mask check ...
> 
> 	if ((miap->s_addr & bestmask.s_addr) || (bestmask.s_addr == 0)) {
> 		bestmask.s_addr = miap->s_addr;
> 		bestlabel = snp->smk_label;
> 	}	
> 
> ... however there is one small problem with this approach (your proposal 
> suffers from the same issue): normally the smack_host_label() code prefers the 
> first matching entry in the list, the change above preserves that with the 
> exception of a 0.0.0.0/0 entry.  Granted, you shouldn't allow that in the 
> first place but I believe it is possible so it is something that needs to be 
> taken into consideration.
> 
hummm... I didn't see it that way; I think this function is basically a reimplementation of IPv4 classless routing (longest match first)?
anyway, I think the cleanest way would be to, well, sort smk_netlbladdr by mask on insertion (perf doesn't matter  here) and this way smack_host_label can stop the loop on first match.
Plus, it would give a nicer /smack/netlabel ouptut :)

so, how should we handle it? apply the patches (with whitespaces damages corrected ;) )  now (as it corrects a bug) an elaborate the cleaner way later?
I think this should go to stable too?

regards
Etienne

>> Signed-off-by: Etienne <etienne.basset@numericable.fr>
>> ------
>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>> index 0278bc0..9d2576d 100644
>> --- a/security/smack/smack_lsm.c
>> +++ b/security/smack/smack_lsm.c
>> @@ -1540,7 +1540,7 @@ static char *smack_host_label(struct sockaddr_in
>> *sip) * If the list entry mask is less specific than the best * already
>> found this entry is uninteresting.
>>                  */
>> -               if ((miap->s_addr | bestmask.s_addr) == bestmask.s_addr)
>> +               if ( ((miap->s_addr | bestmask.s_addr) == bestmask.s_addr)
>> &&  (miap->s_addr | bestmask.s_addr) != 0  ) continue;
>>                 /*
>>                  * This is better than any entry found so far.
