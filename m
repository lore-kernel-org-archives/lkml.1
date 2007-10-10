Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbXJJAd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbXJJAd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 20:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbXJJAdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 20:33:18 -0400
Received: from lixom.net ([66.141.50.11]:58174 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbXJJAdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 20:33:17 -0400
Date: Tue, 9 Oct 2007 19:38:24 -0500
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       linuxppc-dev@ozlabs.org, paulus@samba.org, tgall.foo@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Subject: [PATCH v2] powerpc: don't enable cpu hotplug on mpic-based pseries
Message-ID: <20071010003824.GA8477@lixom.net>
References: <20071008180406.052382073@mini.kroah.org> <20071008180633.GJ7627@kroah.com> <20071009151702.GA19209@lixom.net> <20071009222003.GA21228@kroah.com> <alpine.LFD.0.9999.0710100120340.7766@localhost.localdomain> <alpine.LFD.0.999.0710091625520.3838@woody.linux-foundation.org> <20071010000815.GB7875@lixom.net> <20071010101826.186f1f24.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071010101826.186f1f24.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow cpu hotplug on systems lacking XICS interrupt controller,
since current code is hardcoded for it.


Signed-off-by: Olof Johansson <olof@lixom.net>

---

On Wed, Oct 10, 2007 at 10:18:26AM +1000, Stephen Rothwell wrote:

> > +	struct device_node *np;
> > +	const char *typep;
> > +
> > +	for (np = NULL; (np = of_find_node_by_name(np,
> > +						   "interrupt-controller"));) {
> > +		typep = of_get_property(np, "compatible", NULL);
> > +		if (strstr(typep, "open-pic")) {
> > +			printk(KERN_INFO "CPU Hotplug not supported on "
> > +				"systems using MPIC\n");
> 
> You need an of_node_put(np) here.

Grmbl, you're right.

pseries_discover_pic() doesn't have one, that's where I took the above
logic from. So we're obviously already leaking device node references.

Still, no reason to make it worse.


-Olof

diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 9711eb0..ae85fc0 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -252,6 +252,21 @@ static struct notifier_block pseries_smp_nb = {
 
 static int __init pseries_cpu_hotplug_init(void)
 {
+	struct device_node *np;
+	const char *typep;
+
+	for (np = NULL; (np = of_find_node_by_name(np,
+						   "interrupt-controller"));) {
+		typep = of_get_property(np, "compatible", NULL);
+		if (strstr(typep, "open-pic")) {
+			of_node_put(np);
+
+			printk(KERN_INFO "CPU Hotplug not supported on "
+				"systems using MPIC\n");
+			return 0;
+		}
+	}
+
 	rtas_stop_self_args.token = rtas_token("stop-self");
 	qcss_tok = rtas_token("query-cpu-stopped-state");
 
