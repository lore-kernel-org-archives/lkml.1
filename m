Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbYCHBWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbYCHBWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbYCHBVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:21:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:18250 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbYCHBVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:21:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=PVXl1qJG5+LnS5w4ouzeMpOcgrBXQ9eIKQaK/CuULPl9PvOvklmX6x2nfpt5lHAl6gITDMZ6E2B9o6hgE8qpxfqSy0Mk4Fg6AMjNo3tmblfWopJmnocoTtmb4u43dDa+57cyYbz0AzstkcT3/b+cxFcVLIUluqMp6Nzg11BiCE0=
Date: Sat, 8 Mar 2008 02:16:07 +0100 (CET)
To: LKML <linux-kernel@vger.kernel.org>
cc: Greg Kroah-Hartman <greg@kroah.com>, gregkh@us.ibm.com,
       jesper.juhl@gmail.com
Subject: [PATCH] Fix small mem leak in IBM Hot Plug Controller Driver
Message-ID: <alpine.LNX.1.00.0803080204170.1856@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In drivers/pci/hotplug/ibmphp_ebda.c::ebda_rsrc_controller(), storage is 
allocated with kzalloc() and assigned to 'tmp_slot'.
Then lots of stuff, like ->flag, ->supported_speed etc is set in tmp_slot. 
A bit further down there's then this test : 

  if (!bus_info_ptr1) {
    rc = -ENODEV;
    goto error;
  }

At this point, tmp_slot has not been assigned to anything, so when 
erroring-out we want to free it, but nothing at the 'error:' label free's 
'tmp_slot' - and we can't really free 'tmp_slot' at 'error:' since we may 
jump to that label later when 'tmp_slot' *has* been used and we do not 
want it freed. So, the only sane option left seems to be to 
kfree(tmp_slot) just before jumping to the 'error:' label in the one place 
where this is what actually makes sense. The following patch does just 
that and thus kills off a tiny potential memory leak.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 ibmphp_ebda.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/hotplug/ibmphp_ebda.c b/drivers/pci/hotplug/ibmphp_ebda.c
index 600ed7b..bbccde9 100644
--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -963,6 +963,7 @@ static int __init ebda_rsrc_controller (void)
 
 			bus_info_ptr1 = ibmphp_find_same_bus_num (hpc_ptr->slots[index].slot_bus_num);
 			if (!bus_info_ptr1) {
+				kfree(tmp_slot);
 				rc = -ENODEV;
 				goto error;
 			}


