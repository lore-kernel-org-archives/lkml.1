Return-Path: <linux-kernel-owner+w=401wt.eu-S1030727AbXDNGNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030727AbXDNGNa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 02:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030694AbXDNGNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 02:13:30 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:17580 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030608AbXDNGN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 02:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=jdfDaOfCBG9qvCIpQx1vVs9V5lAR5+7HjES24xXlTWFt2G1WPCLj2VmfDCqpQ5vQw4twnMcXpY+fub0UOarZtHFbPoYSJOuG5sNyX85uWcktFRi4Ot6slY63dryLo8mIhpo/nihVtgPgaA8JSwMB/knbyZ16dY6QAWAvHKvTGmk=
Date: Sat, 14 Apr 2007 15:08:12 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] mod_sysfs_setup() doesn't return errno when kobject_add_dir() failure occurs
Message-ID: <20070414060812.GA25130@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mod_sysfs_setup() doesn't return an errno when kobject_add_dir()
for module "holders" directory fails. So caller of mod_sysfs_setup()
will keep going and get oops.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Index: 2.6-mm/kernel/module.c
===================================================================
--- 2.6-mm.orig/kernel/module.c
+++ 2.6-mm/kernel/module.c
@@ -1423,8 +1423,10 @@ int mod_sysfs_setup(struct module *mod,
 		goto out;
 
 	mod->holders_dir = kobject_add_dir(&mod->mkobj.kobj, "holders");
-	if (!mod->holders_dir)
+	if (!mod->holders_dir) {
+		err = -ENOMEM;
 		goto out_unreg;
+	}
 
 	err = module_param_sysfs_setup(mod, kparam, num_params);
 	if (err)
