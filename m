Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYGVR5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYGVR5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYGVR5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:57:33 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:23393 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbYGVR5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:57:32 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next build error (PNP/IXJ)
Date: Tue, 22 Jul 2008 11:57:13 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <20080722102739.61462b04.randy.dunlap@oracle.com>
In-Reply-To: <20080722102739.61462b04.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221157.14371.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 11:27:39 am Randy Dunlap wrote:
> I'm seeing several build errors in linux-next-20080722 that I haven't
> seen previously, although I don't know what changed to cause this.
> 
> They are all basically the same, in ixj (drivers/telephony/ixj*), when
> CONFIG_PNP=n, and CONFIG_PHONE_IXJ=y or =m (so the actual error message
> varies depending on IXJ=y or =m):
> 
> IXJ=y:
> ixj.c:(.text+0x329d98): undefined reference to `pnp_get_resource'
> or IXJ=m:
> ERROR: "pnp_get_resource" [drivers/telephony/ixj.ko] undefined!
> 
> 
> Suggestions?

I'd use something like the attached.  I don't have a build environment
where CONFIG_PNP=n (all I have is x86 and ia64), so I haven't tested
this.

ixj: don't use PNP interfaces when CONFIG_PNP=n
    
This patch fixes a build problem when CONFIG_PNP=n.
    
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 49cd979..51b7fb4 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -7588,6 +7588,7 @@ static IXJ *new_ixj(unsigned long port)
 
 static int __init ixj_probe_isapnp(int *cnt)
 {               
+#ifdef CONFIG_PNP
 	int probe = 0;
 	int func = 0x110;
         struct pnp_dev *dev = NULL, *old_dev = NULL;
@@ -7664,6 +7665,9 @@ static int __init ixj_probe_isapnp(int *cnt)
 		dev = NULL;
 	}
 	return probe;
+#else
+	return 0;
+#endif
 }
                         
 static int __init ixj_probe_isa(int *cnt)
