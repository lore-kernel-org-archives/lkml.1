Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZDFCU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZDFCU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 22:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZDFCUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 22:20:15 -0400
Received: from smtp108.prem.mail.sp1.yahoo.com ([98.136.44.63]:35063 "HELO
	smtp108.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752745AbZDFCUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 22:20:14 -0400
X-YMail-OSG: MSLnqRMVM1nvFwZW.Tlxowz0ZHESlMU1Pa2pJB12MIYEEsjejAz25GCGk6qPJDn07x72RUcOY6J4FDM369wTxCaLCvUnop2aJXCW.yeUpXPDd9Q.2FyS9OHw9WPht1sSoG0vMoiL47m2sBnW73wgMwcaYSCglYPPDQ98C2Hxzn_Obzvy7ilkQRTq3DMBcArapIrTHr.wYqjAdUZNABEDJz3gFAxxX3RQuf6hCBnZNMFdWQyqAYGDZlchCn22djCovyNqzNPO_CHwFgm7nRsyn4QDOkVG.EG1BFyQhyWuOBLBsC4O
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49D966DB.9070009@schaufler-ca.com>
Date: Sun, 05 Apr 2009 19:20:11 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Etienne Basset <etienne.basset@numericable.fr>
CC: LSM <linux-security-module@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-audit@redhat.com, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] security/smack implement logging V2
References: <49D8700A.8030605@numericable.fr> <49D8EF0C.3020503@schaufler-ca.com> <49D917AB.8000400@numericable.fr>
In-Reply-To: <49D917AB.8000400@numericable.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Basset wrote:
>> It looks like the only difference between these are their non-logging
>> versions is the logging. I say go ahead and add the auditdata parameter
>> to smk_access and smk_curacc and allow for the case where it is NULL.
>>
>>     
> i would prefer keeping a logging and a non-logging variant
> maybe rename smk_access & smk_curacc to smk_access_nolog & smk_curacc_nolog
> Or you really prefer that we pass a NULL when we want the non-logging?
> I guess its a matter of taste, so i let you decide :)
>   

I dislike functions that do nothing but set up another function.


>> It would be nice if audit data was only manipulated if audit is
>> installed, but I don't like the idea of ifdeffing everything
>> very much either. How about a static inline in smack.h that is
>> ifdeffed for audit? smack_audit_init? There would need to be one
>> for each field, too.
>>
>>     
> why not, but instead of a "initialiser" for each field i'll prefer a macro
>  To save some stack we could also conditionnaly define the "common_audit_data"
>
> something like :
>
> #ifdef CONFIG_AUDIT
> #define DEFINE_SMACK_AUDIT_DATA(ad) struct common_audit_data ad
> void smack_audit_init(..) {
>  COMMON_AUDIT_DATA_INIT(...)
> }
> #define SMACK_AUDIT_DATA_SET_FIELD(_ad, _field, _value) (_ad._field = _value)
> ...
> #else
> #define DEFINE_SMACK_AUDIT_DATA(ad)
> void smack_audit_init(..)
> {
> } 
> #define SMACK_AUDIT_DATA_SET_FIELD(_ad, _field, _value) 
> #endif
>   

I'm not convinced. #defines are good for assigning names to constants,
but I saw the original Bourne shell code, where defines were used to
make the code look like ALGOL68, so you have to overcome the fear that
was instilled in me when I was young.

 

>> Now this is tricky. You'll get an audit record for single-label
>> hosts, but not for those that use CIPSO. The former is good, the
>> latter is bad.
>>
>>     
> gargll you're right
>   

I love those french idioms.

Actually, I don't think there's much point in worrying about it.
The audit you do here is correct, and until you can get more subject
information over the wire there isn't much point doing it on the
receiving end.

