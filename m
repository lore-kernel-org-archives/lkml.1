Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0BIDO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 22:14:29 -0500
Received: from smtp110.prem.mail.sp1.yahoo.com ([98.136.44.55]:22649 "HELO
	smtp110.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753150Ab0BIDO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 22:14:27 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: LO21oUUVM1m1NVzNkc6kg6ROOBVmehTOnzOoh2zrhdD6ZoDf5OSCJ.vsW2oZPGHgxWBcYgqwy__pFfJP2YG2itaUQmYxtuMxmRd.lxr4F.fMJhYpo4lSk11vsSEjWVydOtFzg4jXtiOoqA1gGhN3XREdm8TqYVGRdKfzwborokKioesSzETqiymEG98.jOi__PEUfZQ2hI9mxtMN_.cD75Nq7vkaR1vbokbNqaDsZrFZRk25b.bj2gYD2p2wu0p99P7FJkmG.7AufTF3EDuXCHza72MRjBEQXqolNUbjBiHtmERIB_barpTNS4X_GRkCIWsIsUKBjqidxpm6ibQtxuo-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B70D311.8090109@schaufler-ca.com>
Date: Mon, 08 Feb 2010 19:14:25 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: wzt wzt <wzt.wzt@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] security/smack/smack.h: Fix smk_known length
References: <628d1651002080341k34331712l55797971b3546ba4@mail.gmail.com> <alpine.LRH.2.00.1002090827330.1779@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1002090827330.1779@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> (note: please copy security/ patches to the LSM list, cc'd, along with the 
> Smack maintainer).
>
>
> On Mon, 8 Feb 2010, wzt wzt wrote:
>
>   
>> in security/smack/smack.h:
>> struct smack_known {
>>         struct list_head        list;
>>         char                    smk_known[SMK_LABELLEN];
>> but in security/smack/smack_access.c
>> void smack_from_cipso(u32 level, char *cp, char *result)
>> {
>>         strncpy(result, final, SMK_MAXLEN);
>> }
>> miss '\0'.
>>
>> Signed-off-by: wzt <wzt.wzt@gmail.com>
>> Cc: Jmorris <jmorris@namei.org>
>>
>> diff --git a/security/smack/smack.h b/security/smack/smack.h
>> index c6e9aca..600474b 100644
>> --- a/security/smack/smack.h
>> +++ b/security/smack/smack.h
>> @@ -109,7 +109,7 @@ struct smk_netlbladdr {
>>   */
>>  struct smack_known {
>>         struct list_head        list;
>> -       char                    smk_known[SMK_LABELLEN];
>> +       char                    smk_known[SMK_LABELLEN + 1]; /*
>> smk_known + \0 */
>>     

SMK_LABELLEN is already SMK_MAXLEN+1. That's why the strncpy() above
uses SMK_MAXLEN, so that maximum copied will be SMK_MAXLEN+1, including
the trailing '\0'. The only possible case it could miss would be a
label that is SMK_LABELLEN (24 bytes) long, and that would be an error
because Smack labels are limited to SMK_MAXLEN (23 bytes) plus the
trailing '\0'. The strncpy() could easily be strcpy(), as only labels
that have been imported or hand crafted in the code will be in "from".


>>         u32                     smk_secid;
>>         struct smack_cipso      *smk_cipso;
>>         spinlock_t              smk_cipsolock; /* for changing cipso map */
>>
>>     


