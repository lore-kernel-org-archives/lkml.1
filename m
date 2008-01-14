Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbYANPZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbYANPZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbYANPZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:25:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49529 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYANPZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:25:03 -0500
Date: Mon, 14 Jan 2008 16:24:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080114152440.GA9174@elte.hu>
References: <20080110111514.GS25945@bingen.suse.de> <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150553.GA3524@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114150553.GA3524@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> also, in theory we've got a pretty reliable set of the following 
> information:
> 
>   function X references symbol Y
> 
> and we know what type of sections they are in, right?
> 
> could -ffunction-sections be used to delay the categorization of 
> functions to the link stage, and in essence remove the need to mark 
> functions via any of the __init markers?

find below the current set of warnings on -git. There are 62.

for example, instead of the rather cryptic:

  WARNING: vmlinux.o(.text+0x1815e): Section mismatch: reference to 
  .init.text:calibrate_delay (between 'smp_callin' and '__cpu_up')

the following output would be more informative:

--------------------------------->
| function:
|
|  ./init/calibrate.c:void __devinit calibrate_delay(void)
|
| calls:
|
|  ./arch/x86/kernel/smpboot_32.c:static void __cpuinit smp_callin(void)
|
| but calibrate_delay() is __devinit while smp_callin() is __cpuinit. 
| Change smp_callin() to __devinit to resolve this warning.
|-------------------------------->

would result in a lot faster cycles of fixing this.

do we have all the info to print this?

	Ingo

.init.text: calibrate_delay ('smp_callin' <-> '__cpu_up')
.init.text: register_cpu ('arch_register_cpu' <-> 'in_gate_area_no_task')
.init.text: idle_regs ('fork_idle' <-> 'get_task_mm')
.init.text: ('process_zones' <-> 'pageset_cpuup_callback')
.init.text: pcibios_fixup_bus ('pci_scan_child_bus' <-> 'pci_scan_bus_parented')
.init.data: mtrr ('param_set_scroll' <-> 'uvesafb_cn_callback')
.init.data: mtrr ('param_set_scroll' <-> 'uvesafb_cn_callback')
.init.data: pmi_setpal ('param_set_scroll' <-> 'uvesafb_cn_callback')
.init.data: pmi_setpal ('param_set_scroll' <-> 'uvesafb_cn_callback')
.init.text: pci_acpi_scan_root ('acpi_pci_root_add' <-> 'acpi_pci_unregister_driver')
.init.text: ('olympic_open' <-> 'olympic_interrupt')
.init.text: setup_teles3 ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_s0box ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_telespci ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_avm_pcipnp ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_elsa ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_diva ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_sedlbauer ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_netjet_s ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_hfcpci ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_hfcsx ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_niccy ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_bkm_a4t ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_sct_quadro ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_gazel ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_w6692 ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_netjet_u ('checkcard' <-> 'hisax_sched_event')
.init.text: setup_enternow_pci ('checkcard' <-> 'hisax_sched_event')
.init.data: ISACVer ('ISACVersion' <-> 'DC_Close_isac')
.init.text: clear_pending_isac_ints ('inithscxisac' <-> 'HscxVersion')
.init.text: initisac ('inithscxisac' <-> 'HscxVersion')
.init.text: clear_pending_isac_ints ('AVM_card_msg' <-> 'setup_avm_a1_pcmcia')
.init.text: setup_isac ('setup_avm_a1_pcmcia' <-> 'avm_a1p_interrupt')
.init.text: clear_pending_isac_ints ('AVM_card_msg' <-> 'ReadISACfifo_IPAC')
.init.text: initisac ('AVM_card_msg' <-> 'ReadISACfifo_IPAC')
.init.text: clear_pending_isac_ints ('Sedl_card_msg' <-> 'WriteISACfifo')
.init.text: initisac ('Sedl_card_msg' <-> 'WriteISACfifo')
.init.text: initisar ('Sedl_card_msg' <-> 'WriteISACfifo')
.init.text: clear_pending_isac_ints ('NETjet_S_card_msg' <-> 'netjet_s_interrupt')
.init.text: initisac ('NETjet_S_card_msg' <-> 'netjet_s_interrupt')
.init.text: clear_pending_isac_ints ('BKM_card_msg' <-> 'ReadISAC')
.init.text: initisac ('BKM_card_msg' <-> 'ReadISAC')
.init.text: Amd7930_init ('enpci_card_msg' <-> 'ReadWordAmd7930')
.init.text: Amd7930_init ('enpci_card_msg' <-> 'ReadWordAmd7930')
.init.text: snd_usb_caiaq_audio_init ('snd_probe' <-> 'usb_ep1_command_reply_dispatch')
.init.text: snd_usb_caiaq_midi_init ('snd_probe' <-> 'usb_ep1_command_reply_dispatch')
.init.data: _asc_def_iop_base ('advansys_isa_remove' <-> 'advansys_exit')
.init.text: suni_init ('__ksymtab_suni_init' <-> '__ksymtab_scsi_device_lookup')
.init.text: profile_cpu_callback ('profile_cpu_callback_nb.19579' <-> 'prof_cpu_mask')
.init.text: workqueue_cpu_callback ('workqueue_cpu_callback_nb.12756' <-> 'workqueue_mutex')
.init.text: cpu_callback ('cpu_callback_nb.23833' <-> 'shrinker_rwsem')
.init.text: tpm_inf_pnp_probe ('tpm_inf_pnp' <-> 'inf_attr_grp')
.init.data: prism2_plx_id_table ('prism2_plx_drv_id' <-> 'prism2_plx_funcs')
.init.text: asd_aic9410_setup ('asd_pcidev_data' <-> 'dev_attr_revision')
.init.text: asd_aic9410_setup ('asd_pcidev_data' <-> 'dev_attr_revision')
.init.text: asd_aic9405_setup ('asd_pcidev_data' <-> 'dev_attr_revision')
.init.text: megaraid_probe_one ('megaraid_pci_driver_g' <-> 'megaraid_template_g')
.init.text: snd_ad1889_probe ('ad1889_pci' <-> 'ops.23552')
.exit.text: ('qla2xxx_pci_error_detected' <-> 'qla2x00_stop_timer')
.exit.text: ('sym2_io_error_detected' <-> 'sym_set_cam_result_error')
.exit.text: tpm_nsc_remove ('init_nsc' <-> 'init_atmel')
.exit.text: ('asd_pci_probe' <-> 'ips_insert_device')
