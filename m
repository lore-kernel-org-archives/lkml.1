Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbZK3Ufs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbZK3Ufs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZK3Ufs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:35:48 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46912 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZK3Ufr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:35:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=cQWkQQo1YKiKDA4v4cwXzBj8hry6ntMs6Kjsg4RsKpkUzsMbCac8/DUEAKhARixxhz
         3IVFWmQZ/hcxEvJdxj/1paVuDRdoS5+si1XPfQ2+RJkYtuKwSWXyMXor0C3kkAJ05kqU
         nfjoDEuZ8BDzl1M/EltJv0nZVOr1Ajh7XhFJo=
Date: Mon, 30 Nov 2009 21:35:47 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: 2.6.32-rc8: amd64_edac slub error
Message-ID: <20091130203547.GA2838@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Doug Thompson <dougthompson@xmission.com>,
	Borislav Petkov <borislav.petkov@amd.com>
References: <4B1400B3.60300@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B1400B3.60300@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Mon, Nov 30, 2009 at 09:28:19AM -0800, Randy Dunlap wrote:
> Loading amd64_edac_mod on an amd64 system without the expected hardware support
> causes memory usage error(s).

Well, this is new!

> Is this already fixed/patched?  Do you need more info?

Nope :(.

I've tried to reproduce it here by selecting CONFIG_SLUB no success.
Please send me your config.

Also, it would be very helpful if you could enable CONFIG_EDAC_DEBUG and
run it again.

>From looking at the error trace, though, it looks like we're
not allocating enough memory for the struct msr things in
amd64_nb_mce_bank_enabled_on_node(). This is just a hunch though and you
could give the following debug patch a try:

---
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index a38831c..139bc14 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2739,8 +2739,10 @@ static void get_cpus_on_this_dct_cpumask(cpumask_t *mask, int nid)
 	int cpu;
 
 	for_each_online_cpu(cpu)
-		if (amd_get_nb_id(cpu) == nid)
+		if (amd_get_nb_id(cpu) == nid) {
+			pr_err("%s: nid: %d, cpu: %d\n", __func__, nid, cpu);
 			cpumask_set_cpu(cpu, mask);
+		}
 }
 
 /* check MCG_CTL on all the cpus on this node */
@@ -2755,6 +2757,8 @@ static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 
 	get_cpus_on_this_dct_cpumask(&mask, nid);
 
+	pr_err("%s: weight: %d\n", __func__, cpumask_weight(&mask));
+
 	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(&mask), GFP_KERNEL);
 	if (!msrs) {
 		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",

--

PS. I'm travelling till the end of the week and won't have constant
access to mail but I'll do my best to fix this, sorry.

Thanks.

-- 
Regards/Gruss,
    Boris.
