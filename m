Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbZBWNOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbZBWNOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 08:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZBWNNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 08:13:53 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39138 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbZBWNNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 08:13:52 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 23 Feb 2009 14:13:27 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firedtv: reinstate debug logging option
To: Henrik Kurelid <henke@kurelid.se>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <49A26223.7000507@s5r6.in-berlin.de>
Message-ID: <tkrat.32631eff43fd494b@s5r6.in-berlin.de>
References: <49A1BDA2.9080302@s5r6.in-berlin.de>
 <675fd9b9fc8aff6ca0bed1f7cc42b286.squirrel@mail.kurelid.se>
 <49A26223.7000507@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrik Kurelid tells me that FCP debug logging (which I removed during
cleanups) is still useful when working on driver issues together with
end users.  So bring it back in an updated form with only 60% of the
original code footprint.

Logging can be enabled with
# echo -1 > /sys/module/firedtv/parameters/debug

1 instead of -1 enables only FCP header logging,
2 instead of -1 enables only hexdumps of the entire FCP frames.
0 switches logging off again.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Henrik, below the diff is an example session with both debug flags
switched on.  Please check if this is sufficient.

BTW, I'd rather call print_hex_dump() with groupsize=4 instead of 1, but
this would log the data in wrong order on little endian PCs and that's
not useful.  I guess I need to submit a network byte order variant of
print_hex_dump().

 drivers/media/dvb/firewire/firedtv-avc.c |   78 +++++++++++++++++++++++
 1 file changed, 78 insertions(+)

Index: linux/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- linux.orig/drivers/media/dvb/firewire/firedtv-avc.c
+++ linux/drivers/media/dvb/firewire/firedtv-avc.c
@@ -88,6 +88,78 @@ struct avc_response_frame {
 	u8 operand[509];
 };
 
+#define AVC_DEBUG_FCP_SUBACTIONS	1
+#define AVC_DEBUG_FCP_PAYLOADS		2
+
+static int avc_debug;
+module_param_named(debug, avc_debug, int, 0644);
+MODULE_PARM_DESC(debug, "Verbose logging (default = 0"
+	", FCP subactions = "	__stringify(AVC_DEBUG_FCP_SUBACTIONS)
+	", FCP payloads = "	__stringify(AVC_DEBUG_FCP_PAYLOADS)
+	", or all = -1)");
+
+static const char *debug_fcp_ctype(unsigned int ctype)
+{
+	static const char *ctypes[] = {
+		[0x0] = "CONTROL",		[0x1] = "STATUS",
+		[0x2] = "SPECIFIC INQUIRY",	[0x3] = "NOTIFY",
+		[0x4] = "GENERAL INQUIRY",	[0x8] = "NOT IMPLEMENTED",
+		[0x9] = "ACCEPTED",		[0xa] = "REJECTED",
+		[0xb] = "IN TRANSITION",	[0xc] = "IMPLEMENTED/STABLE",
+		[0xd] = "CHANGED",		[0xf] = "INTERIM",
+	};
+	const char *ret = ctype < ARRAY_SIZE(ctypes) ? ctypes[ctype] : NULL;
+
+	return ret ? ret : "?";
+}
+
+static const char *debug_fcp_opcode(unsigned int opcode,
+				    const u8 *data, size_t length)
+{
+	switch (opcode) {
+	case AVC_OPCODE_VENDOR:			break;
+	case AVC_OPCODE_READ_DESCRIPTOR:	return "ReadDescriptor";
+	case AVC_OPCODE_DSIT:			return "DirectSelectInfo.Type";
+	case AVC_OPCODE_DSD:			return "DirectSelectData";
+	default:				return "?";
+	}
+
+	if (length < 7 ||
+	    data[3] != SFE_VENDOR_DE_COMPANYID_0 ||
+	    data[4] != SFE_VENDOR_DE_COMPANYID_1 ||
+	    data[5] != SFE_VENDOR_DE_COMPANYID_2)
+		return "Vendor";
+
+	switch (data[6]) {
+	case SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL:	return "RegisterRC";
+	case SFE_VENDOR_OPCODE_LNB_CONTROL:		return "LNBControl";
+	case SFE_VENDOR_OPCODE_TUNE_QPSK:		return "TuneQPSK";
+	case SFE_VENDOR_OPCODE_HOST2CA:			return "Host2CA";
+	case SFE_VENDOR_OPCODE_CA2HOST:			return "CA2Host";
+	}
+	return "Vendor";
+}
+
+static void debug_fcp(const u8 *data, size_t length)
+{
+	unsigned int subunit_type, subunit_id, op;
+	const char *prefix = data[0] > 7 ? "FCP <- " : "FCP -> ";
+
+	if (avc_debug & AVC_DEBUG_FCP_SUBACTIONS) {
+		subunit_type = data[1] >> 3;
+		subunit_id = data[1] & 7;
+		op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2];
+		printk(KERN_INFO "%ssu=%x.%x l=%d: %-8s - %s\n",
+		       prefix, subunit_type, subunit_id, length,
+		       debug_fcp_ctype(data[0]),
+		       debug_fcp_opcode(op, data, length));
+	}
+
+	if (avc_debug & AVC_DEBUG_FCP_PAYLOADS)
+		print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_NONE, 16, 1,
+			       data, length, false);
+}
+
 static int __avc_write(struct firedtv *fdtv,
 		const struct avc_command_frame *c, struct avc_response_frame *r)
 {
@@ -97,6 +169,9 @@ static int __avc_write(struct firedtv *f
 		fdtv->avc_reply_received = false;
 
 	for (retry = 0; retry < 6; retry++) {
+		if (unlikely(avc_debug))
+			debug_fcp(&c->ctype, c->length);
+
 		err = fdtv->backend->write(fdtv, FCP_COMMAND_REGISTER,
 					   (void *)&c->ctype, c->length);
 		if (err) {
@@ -144,6 +219,9 @@ int avc_recv(struct firedtv *fdtv, void 
 	struct avc_response_frame *r =
 			data - offsetof(struct avc_response_frame, response);
 
+	if (unlikely(avc_debug))
+		debug_fcp(data, length);
+
 	if (length >= 8 &&
 	    r->operand[0] == SFE_VENDOR_DE_COMPANYID_0 &&
 	    r->operand[1] == SFE_VENDOR_DE_COMPANYID_1 &&


This is how a debug session will look like:

(driver probe)

input: FireDTV remote control as /devices/pci0000:00/0000:00:1e.0/0000:05:00.4/fw-host1/input/input11
FCP -> su=5.0 l=12: CONTROL  - ReadDescriptor
FCP -> 00 28 09 00 ff 00 00 08 00 0d 00 00 
FCP <- su=5.0 l=20: ACCEPTED - ReadDescriptor
FCP <- 09 28 09 00 10 00 00 08 00 0d 20 10 00 60 00 00 
FCP <- 01 82 12 00 
DVB: registering new adapter (FireDTV C/CI)
DVB: registering adapter 0 frontend 0 (FireDTV C/CI)...
FCP -> su=5.0 l=12: CONTROL  - ReadDescriptor
FCP -> 00 28 09 80 ff 00 00 00 00 00 00 00 
FCP <- su=5.0 l=64: ACCEPTED - ReadDescriptor
FCP <- 09 28 09 80 10 00 00 34 00 00 00 32 16 20 00 00 
FCP <- 00 00 00 00 ff c0 9a c9 0a c6 00 24 96 00 02 00 
FCP <- 62 00 00 19 00 20 66 e5 9c 30 dc a1 28 94 92 00 
FCP <- ff ff 18 0b 00 03 20 00 80 01 00 00 00 02 00 00 
firedtv 0012870036002bd7-0: Conditional Access Module not enabled
FCP -> su=1f.7 l=8: NOTIFY   - RegisterRC
FCP -> 03 ff 00 00 12 87 0a 00 
FCP <- su=1f.7 l=8: INTERIM  - RegisterRC
FCP <- 0f ff 00 00 12 87 0a 00 

(pressing a key on the remote control)

FCP <- su=1f.7 l=12: CHANGED  - RegisterRC
FCP <- 0d ff 00 00 12 87 0a 03 1f 00 00 00 
FCP -> su=1f.7 l=8: NOTIFY   - RegisterRC
FCP -> 03 ff 00 00 12 87 0a 00 
FCP <- su=1f.7 l=8: INTERIM  - RegisterRC
FCP <- 0f ff 00 00 12 87 0a 00 

(starting kaffeine)

FCP -> su=5.0 l=28: CONTROL  - DirectSelectData
FCP -> 00 28 cb 00 d2 20 00 11 19 00 00 00 00 00 82 6b 
FCP -> 24 01 af 40 00 00 18 00 00 00 00 00 
FCP <- su=5.0 l=28: ACCEPTED - DirectSelectData
FCP <- 09 28 cb 00 d2 20 00 11 19 00 00 00 00 00 82 6b 
FCP <- 24 01 af 40 00 00 18 00 00 00 00 00 
FCP -> su=5.0 l=12: CONTROL  - ReadDescriptor
FCP -> 00 28 09 80 ff 00 00 00 00 00 00 00 
FCP <- su=5.0 l=64: ACCEPTED - ReadDescriptor
FCP <- 09 28 09 80 10 00 00 34 00 00 00 32 16 20 00 00 
FCP <- 00 00 00 00 ff c0 9a c9 0a c6 00 24 96 00 02 00 
FCP <- 62 00 00 19 00 20 7d 6a 9c 30 dc a1 28 94 92 00 
FCP <- ff ff 18 0b 00 03 20 00 80 01 00 00 00 02 00 00 
FCP -> su=5.0 l=16: CONTROL  - DirectSelectData
FCP -> 00 28 cb 00 d2 20 00 00 01 13 80 03 53 00 00 00 
FCP <- su=5.0 l=16: ACCEPTED - DirectSelectData
FCP <- 09 28 cb 00 d2 20 00 00 01 13 80 03 53 00 00 00 
FCP -> su=5.0 l=12: CONTROL  - ReadDescriptor
FCP -> 00 28 09 80 ff 00 00 00 00 00 00 00 
FCP <- su=5.0 l=64: ACCEPTED - ReadDescriptor
FCP <- 09 28 09 80 10 00 00 34 00 00 00 32 16 20 00 00 
FCP <- 00 00 00 00 ff c0 9a c9 0a c6 00 24 96 00 02 00 
FCP <- 62 00 00 19 00 20 95 6a 9c 30 dc a1 28 94 92 00 
FCP <- ff ff 18 0b 00 03 20 00 80 01 00 00 00 02 00 00 
FCP -> su=5.0 l=24: CONTROL  - DirectSelectData
FCP -> 00 28 cb 00 d2 20 00 00 02 13 80 03 53 00 00 13 
FCP -> 80 00 12 00 00 00 00 00 
FCP <- su=5.0 l=24: ACCEPTED - DirectSelectData
FCP <- 09 28 cb 00 d2 20 00 00 02 13 80 03 53 00 00 13 
FCP <- 80 00 12 00 00 00 00 00 
FCP -> su=5.0 l=12: CONTROL  - ReadDescriptor
FCP -> 00 28 09 80 ff 00 00 00 00 00 00 00 
FCP <- su=5.0 l=64: ACCEPTED - ReadDescriptor
FCP <- 09 28 09 80 10 00 00 34 00 00 00 32 16 20 00 00 
FCP <- 00 00 00 00 ff c0 9a c9 0a c6 00 24 96 00 02 00 
FCP <- 62 00 00 19 00 20 ba 6b 9c 30 dc a1 28 94 92 00 
FCP <- ff ff 18 0b 00 03 20 00 80 01 00 00 00 02 00 00 
[...]

-- 
Stefan Richter
-=====-==--= --=- =-===
http://arcgraph.de/sr/

