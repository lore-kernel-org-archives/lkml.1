Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbXIEPVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbXIEPVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932156AbXIEPUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:20:49 -0400
Received: from lixom.net ([66.141.50.11]:57860 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014AbXIEPUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:20:47 -0400
Date: Wed, 5 Sep 2007 09:27:43 -0500
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pcmcia@lists.infradead.org, hch@lst.de, akpm@linux-foundation.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH] pcmcia: Convert io_req_t to use kio_addr_t
Message-ID: <20070905142742.GA1760@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the io_req_t members to kio_addr_t, to allow use on machines with
more than 16 bits worth of IO port address space (ppc64 in this case,
but it applies to others as well).
    
Signed-off-by: Olof Johansson <olof@lixom.net>


---

I'm not at home in the PCMCIA stack, so I'd appreciate some extra eyes
on it to avoid regressions. As far as I can tell, the io_req_t structure
is not exported through any userspace interface and only used internally.

This supersedes the earlier (rejected) "increase ioaddr_t to 32-bits"
patch (http://patchwork.ozlabs.org/linuxppc/patch?id=11908) for ppc64,
since with this change that would not be needed.


Thanks,

Olof

diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index 0ce39de..585c14b 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -65,8 +65,8 @@ extern int ds_pc_debug;
  * Special stuff for managing IO windows, because they are scarce
  */
 
-static int alloc_io_space(struct pcmcia_socket *s, u_int attr, ioaddr_t *base,
-			  ioaddr_t num, u_int lines)
+static int alloc_io_space(struct pcmcia_socket *s, u_int attr, kio_addr_t *base,
+			  kio_addr_t num, u_int lines)
 {
 	int i;
 	kio_addr_t try, align;
@@ -74,14 +74,14 @@ static int alloc_io_space(struct pcmcia_socket *s, u_int attr, ioaddr_t *base,
 	align = (*base) ? (lines ? 1<<lines : 0) : 1;
 	if (align && (align < num)) {
 		if (*base) {
-			ds_dbg(s, 0, "odd IO request: num %#x align %#lx\n",
+			ds_dbg(s, 0, "odd IO request: num %#lx align %#lx\n",
 			       num, align);
 			align = 0;
 		} else
 			while (align && (align < num)) align <<= 1;
 	}
 	if (*base & ~(align-1)) {
-		ds_dbg(s, 0, "odd IO request: base %#x align %#lx\n",
+		ds_dbg(s, 0, "odd IO request: base %#lx align %#lx\n",
 		       *base, align);
 		align = 0;
 	}
@@ -132,8 +132,8 @@ static int alloc_io_space(struct pcmcia_socket *s, u_int attr, ioaddr_t *base,
 } /* alloc_io_space */
 
 
-static void release_io_space(struct pcmcia_socket *s, ioaddr_t base,
-			     ioaddr_t num)
+static void release_io_space(struct pcmcia_socket *s, kio_addr_t base,
+			     kio_addr_t num)
 {
 	int i;
 
diff --git a/include/pcmcia/cs.h b/include/pcmcia/cs.h
index d5838c3..657d653 100644
--- a/include/pcmcia/cs.h
+++ b/include/pcmcia/cs.h
@@ -147,11 +147,11 @@ typedef struct config_req_t {
 
 /* For RequestIO and ReleaseIO */
 typedef struct io_req_t {
-    ioaddr_t	BasePort1;
-    ioaddr_t	NumPorts1;
+    kio_addr_t	BasePort1;
+    kio_addr_t	NumPorts1;
     u_int	Attributes1;
-    ioaddr_t	BasePort2;
-    ioaddr_t	NumPorts2;
+    kio_addr_t	BasePort2;
+    kio_addr_t	NumPorts2;
     u_int	Attributes2;
     u_int	IOAddrLines;
 } io_req_t;
