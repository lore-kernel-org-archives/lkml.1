Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZAETPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZAETPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZAETPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:15:42 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:32868 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZAETPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:15:41 -0500
X-Greylist: delayed 714 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2009 14:15:41 EST
X-RZG-CLASS-ID: mo05
X-RZG-AUTH: :Pm0FVUW6aauhRGJJc5OfA4AU8DM8ZlijdmJYxKn/UQvEQQx8BE8xoj8=
Date: Mon, 5 Jan 2009 20:03:42 +0100
From: Alex Riesen <raa.lkml@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
Subject: BUG: using smp_processor_id() in preemptible [00000000] code:
	dellWirelessCtl/...
Message-ID: <20090105190342.GB6029@blimp.localdomain>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see this often (all the time) with v2.6.28-5716-gfe0bdec. It is a
Dell XPS M1330 (iwl3945, the newer, "...-2" firmware).

Jan  5 19:49:36 blimp kernel: BUG: using smp_processor_id() in preemptible [00000000] code: dellWirelessCtl/14180
Jan  5 19:49:36 blimp kernel: caller is smi_request+0x89/0xc8
Jan  5 19:49:36 blimp kernel: Pid: 14180, comm: dellWirelessCtl Not tainted 2.6.28-t #146
Jan  5 19:49:36 blimp kernel: Call Trace:
Jan  5 19:49:36 blimp kernel:  [<ffffffff8033ee83>] debug_smp_processor_id+0xdb/0xf0
Jan  5 19:49:36 blimp kernel:  [<ffffffff8046a6d8>] smi_request+0x89/0xc8
Jan  5 19:49:36 blimp kernel:  [<ffffffff8046a78e>] smi_request_store+0x77/0xa5
Jan  5 19:49:36 blimp kernel:  [<ffffffff803c69cb>] dev_attr_store+0x1e/0x20
Jan  5 19:49:36 blimp kernel:  [<ffffffff802e66e8>] sysfs_write_file+0xe4/0x119
Jan  5 19:49:36 blimp kernel:  [<ffffffff802a0084>] vfs_write+0xae/0x124
Jan  5 19:49:36 blimp kernel:  [<ffffffff802a01be>] sys_write+0x47/0x70
Jan  5 19:49:36 blimp kernel:  [<ffffffff8020b69b>] system_call_fastpath+0x16/0x1b

The function smi_request:

/**
 * smi_request: generate SMI request
 *
 * Called with smi_data_lock.
 */
static int smi_request(struct smi_cmd *smi_cmd)
{
	cpumask_t old_mask;
	int ret = 0;

	if (smi_cmd->magic != SMI_CMD_MAGIC) {
		dev_info(&dcdbas_pdev->dev, "%s: invalid magic value\n",
			 __func__);
		return -EBADR;
	}

	/* SMI requires CPU 0 */
	old_mask = current->cpus_allowed;
	set_cpus_allowed_ptr(current, &cpumask_of_cpu(0));
	if (smp_processor_id() != 0) {			    <==== here?
		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
			__func__);
		ret = -EBUSY;
		goto out;
	}

	/* generate SMI */
	asm volatile (
		"outb %b0,%w1"
		: /* no output args */
		: "a" (smi_cmd->command_code),
		  "d" (smi_cmd->command_address),
		  "b" (smi_cmd->ebx),
		  "c" (smi_cmd->ecx)
		: "memory"
	);

out:
	set_cpus_allowed_ptr(current, &old_mask);
	return ret;
}

