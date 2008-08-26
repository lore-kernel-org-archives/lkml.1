Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbYHZUIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbYHZUIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYHZUH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:07:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbYHZUH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:07:57 -0400
Date: Tue, 26 Aug 2008 13:06:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>, Auke Kok <auke-jan.h.kok@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: e1000 horridness (was Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG
 at mm/vmalloc.c - bisected)
In-Reply-To: <48B45FA2.8040603@garzik.org>
Message-ID: <alpine.LFD.1.10.0808261257210.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
 <48B45FA2.8040603@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Jeff Garzik wrote:
> 
> e1000_check_options builds a struct (singular) on the stack, really... struct
> e1000_option is reasonably small.

No it doesn't.

Look a bit more closely.

It builds a struct (singular) MANY MANY times. It also then builds up a 
huge e1000_opt_list[] array, even though it is const and should be static 
(and const).

I know. I wrote a patch to FIX it.

Here's the patch. It shrinks the stack from 1152 bytes to 192 bytes (the 
first version, that only did the e1000_option part, got it down to 600 
bytes). About half comes from not using multiple "e1000_option" 
structures, the other half comes from turning the "e1000_opt_list[]" 
arrays into "static const" instead, so that gcc doesn't copy them onto the 
stack.

Most of the patch is actually doing things like turning

	struct struct e1000_option opt = {

(which declares a _new_ e1000_option variable each time) into

	opt = (struct e1000_option) {

which just re-uses the single variable.

It becomes slightly larger than that, because some places the "opt = .." 
had to be moved around, since it's no longer a variable declaration, but a 
regular assignment.

The rest is just adding "const" to the right places, and turning

	struct e1000_opt_list speed_list[] = ..

into

	static const struct e1000_opt_list speed_list[] = ..

instead, and fixing the indentation to be more straightforward.

I have not tested the dang thing, but I think it's correct. And it turns 
stack usage from "totally horrible and broken" into "pretty reasonable".

		Linus

---
 drivers/net/e1000/e1000_param.c |   81 +++++++++++++++++++++-----------------
 1 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/drivers/net/e1000/e1000_param.c b/drivers/net/e1000/e1000_param.c
index b9f90a5..213437d 100644
--- a/drivers/net/e1000/e1000_param.c
+++ b/drivers/net/e1000/e1000_param.c
@@ -208,7 +208,7 @@ struct e1000_option {
 		} r;
 		struct { /* list_option info */
 			int nr;
-			struct e1000_opt_list { int i; char *str; } *p;
+			const struct e1000_opt_list { int i; char *str; } *p;
 		} l;
 	} arg;
 };
@@ -242,7 +242,7 @@ static int __devinit e1000_validate_option(unsigned int *value,
 		break;
 	case list_option: {
 		int i;
-		struct e1000_opt_list *ent;
+		const struct e1000_opt_list *ent;
 
 		for (i = 0; i < opt->arg.l.nr; i++) {
 			ent = &opt->arg.l.p[i];
@@ -279,7 +279,9 @@ static void e1000_check_copper_options(struct e1000_adapter *adapter);
 
 void __devinit e1000_check_options(struct e1000_adapter *adapter)
 {
+	struct e1000_option opt;
 	int bd = adapter->bd_number;
+
 	if (bd >= E1000_MAX_NIC) {
 		DPRINTK(PROBE, NOTICE,
 		       "Warning: no configuration for board #%i\n", bd);
@@ -287,19 +289,21 @@ void __devinit e1000_check_options(struct e1000_adapter *adapter)
 	}
 
 	{ /* Transmit Descriptor Count */
-		struct e1000_option opt = {
+		struct e1000_tx_ring *tx_ring = adapter->tx_ring;
+		int i;
+		e1000_mac_type mac_type = adapter->hw.mac_type;
+
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Transmit Descriptors",
 			.err  = "using default of "
 				__MODULE_STRING(E1000_DEFAULT_TXD),
 			.def  = E1000_DEFAULT_TXD,
-			.arg  = { .r = { .min = E1000_MIN_TXD }}
+			.arg  = { .r = {
+				.min = E1000_MIN_TXD,
+				.max = mac_type < e1000_82544 ? E1000_MAX_TXD : E1000_MAX_82544_TXD
+				}}
 		};
-		struct e1000_tx_ring *tx_ring = adapter->tx_ring;
-		int i;
-		e1000_mac_type mac_type = adapter->hw.mac_type;
-		opt.arg.r.max = mac_type < e1000_82544 ?
-			E1000_MAX_TXD : E1000_MAX_82544_TXD;
 
 		if (num_TxDescriptors > bd) {
 			tx_ring->count = TxDescriptors[bd];
@@ -313,19 +317,21 @@ void __devinit e1000_check_options(struct e1000_adapter *adapter)
 			tx_ring[i].count = tx_ring->count;
 	}
 	{ /* Receive Descriptor Count */
-		struct e1000_option opt = {
+		struct e1000_rx_ring *rx_ring = adapter->rx_ring;
+		int i;
+		e1000_mac_type mac_type = adapter->hw.mac_type;
+
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Receive Descriptors",
 			.err  = "using default of "
 				__MODULE_STRING(E1000_DEFAULT_RXD),
 			.def  = E1000_DEFAULT_RXD,
-			.arg  = { .r = { .min = E1000_MIN_RXD }}
+			.arg  = { .r = {
+				.min = E1000_MIN_RXD,
+				.max = mac_type < e1000_82544 ? E1000_MAX_RXD : E1000_MAX_82544_RXD
+			}}
 		};
-		struct e1000_rx_ring *rx_ring = adapter->rx_ring;
-		int i;
-		e1000_mac_type mac_type = adapter->hw.mac_type;
-		opt.arg.r.max = mac_type < e1000_82544 ? E1000_MAX_RXD :
-			E1000_MAX_82544_RXD;
 
 		if (num_RxDescriptors > bd) {
 			rx_ring->count = RxDescriptors[bd];
@@ -339,7 +345,7 @@ void __devinit e1000_check_options(struct e1000_adapter *adapter)
 			rx_ring[i].count = rx_ring->count;
 	}
 	{ /* Checksum Offload Enable/Disable */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = enable_option,
 			.name = "Checksum Offload",
 			.err  = "defaulting to Enabled",
@@ -363,7 +369,7 @@ void __devinit e1000_check_options(struct e1000_adapter *adapter)
 			 { E1000_FC_FULL,    "Flow Control Enabled" },
 			 { E1000_FC_DEFAULT, "Flow Control Hardware Default" }};
 
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = list_option,
 			.name = "Flow Control",
 			.err  = "reading default settings from EEPROM",
@@ -381,7 +387,7 @@ void __devinit e1000_check_options(struct e1000_adapter *adapter)
 		}
 	}
 	{ /* Transmit Interrupt Delay */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Transmit Interrupt Delay",
 			.err  = "using default of " __MODULE_STRING(DEFAULT_TIDV),
@@ -399,7 +405,7 @@ void __devinit e1000_check_options(struct e1000_adapter *adapter)
 		}
 	}
 	{ /* Transmit Absolute Interrupt Delay */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Transmit Absolute Interrupt Delay",
 			.err  = "using default of " __MODULE_STRING(DEFAULT_TADV),
@@ -417,7 +423,7 @@ void __devinit e1000_check_options(struct e1000_adapter *adapter)
 		}
 	}
 	{ /* Receive Interrupt Delay */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Receive Interrupt Delay",
 			.err  = "using default of " __MODULE_STRING(DEFAULT_RDTR),
@@ -435,7 +441,7 @@ void __devinit e1000_check_options(struct e1000_adapter *adapter)
 		}
 	}
 	{ /* Receive Absolute Interrupt Delay */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Receive Absolute Interrupt Delay",
 			.err  = "using default of " __MODULE_STRING(DEFAULT_RADV),
@@ -453,7 +459,7 @@ void __devinit e1000_check_options(struct e1000_adapter *adapter)
 		}
 	}
 	{ /* Interrupt Throttling Rate */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = range_option,
 			.name = "Interrupt Throttling Rate (ints/sec)",
 			.err  = "using default of " __MODULE_STRING(DEFAULT_ITR),
@@ -497,7 +503,7 @@ void __devinit e1000_check_options(struct e1000_adapter *adapter)
 		}
 	}
 	{ /* Smart Power Down */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = enable_option,
 			.name = "PHY Smart Power Down",
 			.err  = "defaulting to Disabled",
@@ -513,7 +519,7 @@ void __devinit e1000_check_options(struct e1000_adapter *adapter)
 		}
 	}
 	{ /* Kumeran Lock Loss Workaround */
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = enable_option,
 			.name = "Kumeran Lock Loss Workaround",
 			.err  = "defaulting to Enabled",
@@ -578,16 +584,18 @@ static void __devinit e1000_check_fiber_options(struct e1000_adapter *adapter)
 
 static void __devinit e1000_check_copper_options(struct e1000_adapter *adapter)
 {
+	struct e1000_option opt;
 	unsigned int speed, dplx, an;
 	int bd = adapter->bd_number;
 
 	{ /* Speed */
-		struct e1000_opt_list speed_list[] = {{          0, "" },
-						      {   SPEED_10, "" },
-						      {  SPEED_100, "" },
-						      { SPEED_1000, "" }};
+		static const struct e1000_opt_list speed_list[] = {
+			{          0, "" },
+			{   SPEED_10, "" },
+			{  SPEED_100, "" },
+			{ SPEED_1000, "" }};
 
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = list_option,
 			.name = "Speed",
 			.err  = "parameter ignored",
@@ -604,11 +612,12 @@ static void __devinit e1000_check_copper_options(struct e1000_adapter *adapter)
 		}
 	}
 	{ /* Duplex */
-		struct e1000_opt_list dplx_list[] = {{           0, "" },
-						     { HALF_DUPLEX, "" },
-						     { FULL_DUPLEX, "" }};
+		static const struct e1000_opt_list dplx_list[] = {
+			{           0, "" },
+			{ HALF_DUPLEX, "" },
+			{ FULL_DUPLEX, "" }};
 
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = list_option,
 			.name = "Duplex",
 			.err  = "parameter ignored",
@@ -637,7 +646,7 @@ static void __devinit e1000_check_copper_options(struct e1000_adapter *adapter)
 		       "parameter ignored\n");
 		adapter->hw.autoneg_advertised = AUTONEG_ADV_DEFAULT;
 	} else { /* Autoneg */
-		struct e1000_opt_list an_list[] =
+		static const struct e1000_opt_list an_list[] =
 			#define AA "AutoNeg advertising "
 			{{ 0x01, AA "10/HD" },
 			 { 0x02, AA "10/FD" },
@@ -671,7 +680,7 @@ static void __devinit e1000_check_copper_options(struct e1000_adapter *adapter)
 			 { 0x2e, AA "1000/FD, 100/FD, 100/HD, 10/FD" },
 			 { 0x2f, AA "1000/FD, 100/FD, 100/HD, 10/FD, 10/HD" }};
 
-		struct e1000_option opt = {
+		opt = (struct e1000_option) {
 			.type = list_option,
 			.name = "AutoNeg",
 			.err  = "parameter ignored",
