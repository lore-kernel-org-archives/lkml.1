Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbYCLFfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbYCLFfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 01:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYCLFfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 01:35:32 -0400
Received: from hs-out-0708.google.com ([64.233.178.248]:10713 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbYCLFfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 01:35:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=l+ZIdyUnEJX5FEXJSQdsGnOWQXhUyvIGmTZXD2x1xXeoXARi16KzGyO8BOIvPhlCpoTanDQPwY+lH3zpafCHirt84EbCNn+i3okU17X7s/ej7DUcckuu9nnK1wDG7Ii3MAoAa0T5Tje6xrhVKcucGGFXIGlELKDanvvCRhHcuYM=
Message-ID: <97a0a9ac0803112235l157706adoa84b131549a46049@mail.gmail.com>
Date: Tue, 11 Mar 2008 23:35:28 -0600
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: physmap and "request_module: runaway loop modprobe net-pf-1"
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All

On machines that register a physmap flash platform device (e.g. many
arm machines), parse_mtd_partitions() in drivers/mtd/mtdpart.c can
cause the following output in the boot log:

request_module: runaway loop modprobe net-pf-1
modprobe: FATAL: Could not load
/lib/modules/2.6.25-rc4-iop32x/modules.dep: No such file or directory

modprobe: FATAL: Could not load
/lib/modules/2.6.25-rc4-iop32x/modules.dep: No such file or directory

modprobe: FATAL: Could not load
/lib/modules/2.6.25-rc4-iop32x/modules.dep: No such file or directory
...

To illustrate how this can occur, I'll use the example where
CONFIG_KMOD=y, CONFIG_MTD_PARTITIONS=y, CONFIG_MTD_REDBOOT_PARTS=y,
and CONFIG_CMDLINE_PARTS is not set. I'll also refer to the following
code segment which is in drivers/mtd/mtdpart.c:parse_mtd_partitions():

	for ( ; ret <= 0 && *types; types++) {
		parser = get_partition_parser(*types);
#ifdef CONFIG_KMOD
		if (!parser && !request_module("%s", *types))
				parser = get_partition_parser(*types);
#endif
		if (!parser) {
			printk(KERN_NOTICE "%s partition parsing not available\n",
			       *types);
			continue;
		}
		ret = (*parser->parse_fn)(master, pparts, origin);
		if (ret > 0) {
			printk(KERN_NOTICE "%d %s partitions found on MTD device %s\n",
			       ret, parser->name, master->name);
		}
		put_partition_parser(parser);
	}

I should note that I am assuming (because I don't understand how) that
request_module() requires net-pf-1 to succeed. This assumption is
based on my observation of the request_module message
("request_module: runaway loop modprobe net-pf-1"), and that
af_unix_init() (net-pf-1 initialization) is called only after the call
to request_module() in this example.

Based on the configuration and assumptions described above, the
sequence of events that cause the boot log messages above are:

1. the first call to get_partition_parser() in parse_mtd_partitions()
does not find the parser in the the list of registered parsers, i.e.
get_partition_parser() returns a NULL pointer. In this example, the
only registered parser in the list is called Redboot;

2. parse_mtd_partitions() calls request_module() with (in this
example) the parameter "cmdlinepart";

3. request_module() complains (request_module: runaway loop modprobe
net-pf-1, etc.) because af_unix_init() has not been called. The boot
log shows that af_unix_init() is called only after
parse_mtd_partitions() finishes.

register_mtd_parser: RedBoot
physmap platform flash device: 00080000 at f0000000
Found: ST M29W400DB
physmap-flash.0: Found 1 x16 devices at 0x0 in 16-bit bank
number of JEDEC chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
parse_mtd_partitions:
get_partition_parser: name=cmdlinepart
get_partition_parser: p->name=RedBoot
get_partition_parser: p->owner=00000000
get_partition_parser: ret=00000000
parse_mtd_partitions: cmdlinepart
request_module: runaway loop modprobe net-pf-1
modprobe: FATAL: Could not load
/lib/modules/2.6.25-rc4-iop32x/modules.dep: No such file or directory

modprobe: FATAL: Could not load
/lib/modules/2.6.25-rc4-iop32x/modules.dep: No such file or directory

modprobe: FATAL: Could not load
/lib/modules/2.6.25-rc4-iop32x/modules.dep: No such file or directory

<--- 47 repeated modprobe messages deleted --->
parse_mtd_partitions: request_module called
cmdlinepart partition parsing not available
get_partition_parser: name=RedBoot
get_partition_parser: p->name=RedBoot
get_partition_parser: p->owner=00000000
get_partition_parser: ret->name=RedBoot
get_partition_parser: ret=c02b0f8c
parse_mtd_partitions: RedBoot
parse_mtd_partitions: request_module called
Searching for RedBoot partition table in physmap-flash.0 at offset 0x70000
No RedBoot partition table detected in physmap-flash.0
parse_mtd_partitions: end of function
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
rtc-rs5c372 0-0032: rs5c372a found, 24hr, driver version 0.5
rtc-rs5c372 0-0032: rtc core: registered rtc-rs5c372 as rtc0
iop-adma iop-adma.0: Intel(R) IOP: ( cpy intr )
iop-adma iop-adma.1: Intel(R) IOP: ( cpy intr )
NET: Registered protocol family 26
TCP bic registered
af_unix_init:
NET: Registered protocol family 1
NET: Registered protocol family 17
XScale DSP coprocessor detected.
registered taskstats version 1
rtc-rs5c372 0-0032: setting system clock to 2008-03-11 03:16:46 UTC (1205205406)

The reason parse_mtd_partitions() tries to use cmdlinepart, even
though it is not a registered parsing scheme when CONFIG_CMDLINE_PARTS
is not set, is because cmdlinepart is hard coded in
drivers/mtd/maps/physmap.c:

#ifdef CONFIG_MTD_PARTITIONS
static const char *part_probe_types[] = { "cmdlinepart", "RedBoot", NULL };
#endif

The simple solution to eliminating the messages in the boot log
appears to be to ensure that, for machines that use a physmap flash
device, CONFIG_MTD_REDBOOT_PARTS and CONFIG_CMDLINE_PARTS are set if
CONFIG_MTD_PARTITIONS is set. However, the problem also occurs if
CONFIG_MTD_REDBOOT_PARTS is configured to be built as a module,
because again, request_module() fails because af_unix_init() has not
been called.

It would be simpler if all parsing code could only be built into the
kernel. In this case, built in parsers would be registered by the time
parse_mtd_partitions() is called, so the call to request_module() in
parse_mtd_partitions() could be removed:

#ifdef CONFIG_KMOD
		if (!parser && !request_module("%s", *types))
				parser = get_partition_parser(*types);
#endif

This solution would require simply changing the parser configuration
options to bool in drivers/mtd/Kconfig. Is there a reason to allow the
parsing code to be built as a module?

Alternatively, if selecting CONFIG_MTD_PARTITIONS and not selecting
both CONFIG_MTD_REDBOOT_PARTS and CONFIG_CMDLINE_PARTS, or selecting
CONFIG_MTD_PARTITIONS and not selecting CONFIG_CMDLINE_PARTS and
selecting CONFIG_MTD_REDBOOT_PARTS as a module, are valid
configurations, it seems that parse_mtd_partitions() must be called
only after af_unix_init() has been called. Is this possible?

Lastly, does anybody care because this problem does not cause the
kernel to crash? :-)

Please CC me when replying because I am not subscribed to the list.

Thanks.

Gordon

-- 
Gordon Farquharson
GnuPG Key ID: 32D6D676
