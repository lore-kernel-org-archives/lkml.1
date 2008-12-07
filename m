Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbYLGAfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbYLGAfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 19:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYLGAfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 19:35:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417AbYLGAfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 19:35:03 -0500
Date: Sat, 6 Dec 2008 16:34:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Palix <npalix@diku.dk>
Cc: paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH linux-next] powerpc/powermac: Add missing of_node_put
Message-Id: <20081206163449.60757c4a.akpm@linux-foundation.org>
In-Reply-To: <200812021445.18670.npalix@diku.dk>
References: <200812021445.18670.npalix@diku.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008 14:45:18 +0100 Nicolas Palix <npalix@diku.dk> wrote:

> --- a/arch/powerpc/platforms/powermac/time.c
> +++ b/arch/powerpc/platforms/powermac/time.c
> @@ -265,12 +265,14 @@ int __init via_calibrate_decr(void)
>  	struct resource rsrc;
>  
>  	vias = of_find_node_by_name(NULL, "via-cuda");
>  	if (vias == 0)
>  		vias = of_find_node_by_name(NULL, "via-pmu");
>  	if (vias == 0)
>  		vias = of_find_node_by_name(NULL, "via");
>  	if (vias == 0 || of_address_to_resource(vias, 0, &rsrc))
>  		return 0;
> +	of_node_put(vias);
> +

This still misses a path - if that `return 0' is taken, we still leak
the reference.

This is reason #345 why sprinkling return statements all over your code
is bad.

I fixed it up thusly.  Please check.




of_node_put is needed before discarding a value received from
of_find_node_by_name, eg in error handling code or when the device
node is no longer used.

The semantic match that catches the bug is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression struct device_node *n;
position p1, p2;
struct device_node *n1;
statement S;
identifier f;
expression E;
expression *ptr != NULL;
@@

n@p1 = of_find_node_by_name(...)
...
if (!n) S
... when != of_node_put(n)
    when != n1 = f(n,...)
    when != E = n
    when any
    when strict
(
  return \(0\|<+...n...+>\|ptr\);
|
return@p2 ...;
|
  of_node_put(n);
|
  n1 = f(n,...)
|
  E = n
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s of_find_node_by_name %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---

index bcf50d7..800fcce 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/powermac/pci.c  |    2 ++
 arch/powerpc/platforms/powermac/time.c |    9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/platforms/powermac/pci.c~powerpc-powermac-add-missing-of_node_put arch/powerpc/platforms/powermac/pci.c
--- a/arch/powerpc/platforms/powermac/pci.c~powerpc-powermac-add-missing-of_node_put
+++ a/arch/powerpc/platforms/powermac/pci.c
@@ -661,6 +661,7 @@ static void __init init_second_ohare(voi
 			pci_find_hose_for_OF_device(np);
 		if (!hose) {
 			printk(KERN_ERR "Can't find PCI hose for OHare2 !\n");
+			of_node_put(np);
 			return;
 		}
 		early_read_config_word(hose, bus, devfn, PCI_COMMAND, &cmd);
@@ -669,6 +670,7 @@ static void __init init_second_ohare(voi
 		early_write_config_word(hose, bus, devfn, PCI_COMMAND, cmd);
 	}
 	has_second_ohare = 1;
+	of_node_put(np);
 }
 
 /*
diff -puN arch/powerpc/platforms/powermac/time.c~powerpc-powermac-add-missing-of_node_put arch/powerpc/platforms/powermac/time.c
--- a/arch/powerpc/platforms/powermac/time.c~powerpc-powermac-add-missing-of_node_put
+++ a/arch/powerpc/platforms/powermac/time.c
@@ -270,11 +270,11 @@ int __init via_calibrate_decr(void)
 	if (vias == 0)
 		vias = of_find_node_by_name(NULL, "via");
 	if (vias == 0 || of_address_to_resource(vias, 0, &rsrc))
-		return 0;
+		goto fail;
 	via = ioremap(rsrc.start, rsrc.end - rsrc.start + 1);
 	if (via == NULL) {
 		printk(KERN_ERR "Failed to map VIA for timer calibration !\n");
-		return 0;
+		goto fail;
 	}
 
 	/* set timer 1 for continuous interrupts */
@@ -297,8 +297,11 @@ int __init via_calibrate_decr(void)
 	ppc_tb_freq = (dstart - dend) * 100 / 6;
 
 	iounmap(via);
-	
+
 	return 1;
+fail:
+	of_node_put(vias);
+	return 0;
 }
 #endif
 
_

