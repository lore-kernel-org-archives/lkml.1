Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbZDFGRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbZDFGRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 02:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZDFGRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 02:17:45 -0400
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:59119 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZDFGRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 02:17:44 -0400
Message-ID: <49D99E84.3000708@numericable.fr>
Date: Mon, 06 Apr 2009 08:17:40 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: LSM <linux-security-module@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-audit@redhat.com
Subject: Re: [PATCH 2/2] security/smack implement logging V2
References: <49D8700A.8030605@numericable.fr> <49D8EF0C.3020503@schaufler-ca.com> <49D917AB.8000400@numericable.fr> <49D966DB.9070009@schaufler-ca.com>
In-Reply-To: <49D966DB.9070009@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> Etienne Basset wrote:
>>> It looks like the only difference between these are their non-logging
>>> versions is the logging. I say go ahead and add the auditdata parameter
>>> to smk_access and smk_curacc and allow for the case where it is NULL.
>>>
>>>     
>> i would prefer keeping a logging and a non-logging variant
>> maybe rename smk_access & smk_curacc to smk_access_nolog & smk_curacc_nolog
>> Or you really prefer that we pass a NULL when we want the non-logging?
>> I guess its a matter of taste, so i let you decide :)
>>   
> 
> I dislike functions that do nothing but set up another function.
> 
> 
fair enough

>>> It would be nice if audit data was only manipulated if audit is
>>> installed, but I don't like the idea of ifdeffing everything
>>> very much either. How about a static inline in smack.h that is
>>> ifdeffed for audit? smack_audit_init? There would need to be one
>>> for each field, too.
>>>
>>>     
>> why not, but instead of a "initialiser" for each field i'll prefer a macro
>>  To save some stack we could also conditionnaly define the "common_audit_data"
>>
>> something like :
>>
>> #ifdef CONFIG_AUDIT
>> #define DEFINE_SMACK_AUDIT_DATA(ad) struct common_audit_data ad
>> void smack_audit_init(..) {
>>  COMMON_AUDIT_DATA_INIT(...)
>> }
>> #define SMACK_AUDIT_DATA_SET_FIELD(_ad, _field, _value) (_ad._field = _value)
>> ...
>> #else
>> #define DEFINE_SMACK_AUDIT_DATA(ad)
>> void smack_audit_init(..)
>> {
>> } 
>> #define SMACK_AUDIT_DATA_SET_FIELD(_ad, _field, _value) 
>> #endif
>>   
> 
> I'm not convinced. #defines are good for assigning names to constants,
> but I saw the original Bourne shell code, where defines were used to
> make the code look like ALGOL68, so you have to overcome the fear that
> was instilled in me when I was young.
> 
>
hum... it's already everywhere :)
to save stack space in the NON-AUDIT case, maybe something like :

struct smk_audit_data {
#ifdef CONFIG_AUDIT
	struct common_audit_data;
#endif
}

(which i don't really like either, but we have to find a compromise between
"bloat" in the NON-AUDIT case and clean-looking code) 

sure, i could make the "initialisers" static inline, the only downside is more C code
(and more homework for me ;) )
  
> 
>>> Now this is tricky. You'll get an audit record for single-label
>>> hosts, but not for those that use CIPSO. The former is good, the
>>> latter is bad.
>>>
>>>     
>> gargll you're right
>>   
> 
> I love those french idioms.
> 
:)

> Actually, I don't think there's much point in worrying about it.
> The audit you do here is correct, and until you can get more subject
> information over the wire there isn't much point doing it on the
> receiving end.
> 
ok
thanks
Etienne
