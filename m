Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbXJWVcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbXJWVcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbXJWVb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:31:26 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:2241 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbXJWVbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:31:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=k8p8yhUmcXl1c9s2/JcBiHmnUfqJFccug10N/67uW9npOa4oTBa5Hgcob1OPyzhElI+cYiD0uPAtDduqYlt8vPc9KiKMnKdnbMI21VG+t0tB2J1x6KiXK+XBszlpU7e0w0nism0+X2sJbYbhjrdyv2PQVmtSkreLmOPSPvntZdM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: const vs __{dev}initdata
Date: Tue, 23 Oct 2007 23:35:56 +0200
User-Agent: KMail/1.9.7
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710232335.56766.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

It seems that const cannot be (officialy) mixed with __{dev}initdata,

include/linux/init.h:
...
 *
 * Also note, that this data cannot be "const".
 */
...

[ BTW Greg: this doesn't seem to be mentioned in LDD3. ]

Any reason for this limitation (other than not having .init.rodata section
and __const__{dev}initdata tag)?  There are places where we really would like
to have both, i.e. struct ide_port_info in drivers/ide.

Quick and lame grep on the current git tree results in 81 (besides 32 in
drivers/ide) occurences of const + "initdata".  Probably most work because
of the unreliable-in-the-long-term workaround (if driver's .init.data section
contains only read-only data the whole section becomes READONLY and the
driver builds fine), some have const commented out currently but some may
actually fail to build with CONFIG_HOTPLUG=n:

./arch/frv/mb93090-mb00/pci-irq.c:static const uint8_t __initdata pci_bus0_irq_routing[32][4] = {
./arch/frv/kernel/setup.c:static const struct clock_cmode __pminitdata *clock_cmodes;
./arch/mips/mips-boards/malta/malta_setup.c:		static const int pciclocks[] __initdata = {
./arch/mips/pci/fixup-mpc30x.c:static const int internal_func_irqs[] __initdata = {
./arch/mips/pci/fixup-mpc30x.c:static const int irq_tab_mpc30x[] __initdata = {
./arch/h8300/platform/h8s/ints_h8s.c:const int __initdata h8300_saved_vectors[]={
./arch/h8300/platform/h8s/ints_h8s.c:const unsigned long __initdata h8300_trap_table[NR_TRAPS]={
./arch/arm/mach-at91/clock.c:static struct clk *const standard_pmc_clocks[] __initdata = {
./arch/arm/mach-davinci/irq.c:static const u8 default_priorities[DAVINCI_N_AINTC_IRQ] __initdata = {
./arch/x86/xen/enlighten.c:static const struct pv_info xen_info __initdata = {
./arch/x86/xen/enlighten.c:static const struct pv_init_ops xen_init_ops __initdata = {
./arch/x86/xen/enlighten.c:static const struct pv_time_ops xen_time_ops __initdata = {
./arch/x86/xen/enlighten.c:static const struct pv_cpu_ops xen_cpu_ops __initdata = {
./arch/x86/xen/enlighten.c:static const struct pv_irq_ops xen_irq_ops __initdata = {
./arch/x86/xen/enlighten.c:static const struct pv_apic_ops xen_apic_ops __initdata = {
./arch/x86/xen/enlighten.c:static const struct pv_mmu_ops xen_mmu_ops __initdata = {
./arch/x86/xen/enlighten.c:static const struct smp_ops xen_smp_ops __initdata = {
./arch/x86/xen/enlighten.c:static const struct machine_ops __initdata xen_machine_ops = {
./arch/x86/kernel/cpu/cpufreq/longhaul.h:static const int __initdata samuel1_clock_ratio[16] = {
./arch/x86/kernel/cpu/cpufreq/longhaul.h:static const int __initdata samuel1_eblcr[16] = {
./arch/x86/kernel/cpu/cpufreq/longhaul.h:static const int __initdata samuel2_eblcr[16] = {
./arch/x86/kernel/cpu/cpufreq/longhaul.h:static const int __initdata ezra_clock_ratio[16] = {
./arch/x86/kernel/cpu/cpufreq/longhaul.h:static const int __initdata ezra_eblcr[16] = {
./arch/x86/kernel/cpu/cpufreq/longhaul.h:static const int __initdata ezrat_clock_ratio[32] = {
./arch/x86/kernel/cpu/cpufreq/longhaul.h:static const int __initdata ezrat_eblcr[32] = {
./arch/x86/kernel/cpu/cpufreq/longhaul.h:static const int __initdata  nehemiah_clock_ratio[32] = {
./arch/x86/kernel/cpu/cpufreq/longhaul.h:static const int __initdata nehemiah_eblcr[32] = {
./arch/x86/kernel/cpu/cpufreq/longhaul.h:static const struct mV_pos __initdata vrm85_mV[32] = {
./arch/x86/kernel/cpu/cpufreq/longhaul.h:static const unsigned char __initdata mV_vrm85[32] = {
./arch/x86/kernel/cpu/cpufreq/longhaul.h:static const struct mV_pos __initdata mobilevrm_mV[32] = {
./arch/x86/kernel/cpu/cpufreq/longhaul.h:static const unsigned char __initdata mV_mobilevrm[32] = {
./arch/powerpc/platforms/cell/spu_base.c:		 * conflicts for const and __initdata with different compiler
./drivers/atm/eni.c:static const char *media_name[] __devinitdata = {
./drivers/infiniband/hw/mlx4/main.c:static const char mlx4_ib_version[] __devinitdata =
./drivers/infiniband/hw/mthca/mthca_main.c:static const char mthca_version[] __devinitdata =
./drivers/net/typhoon.c:static const char version[] __devinitdata =
./drivers/net/typhoon.c:static const struct typhoon_card_info typhoon_card_info[] __devinitdata = {
./drivers/net/via-velocity.c:static const struct velocity_info_tbl chip_info_table[] __devinitdata = {
./drivers/net/via-velocity.c:static const struct pci_device_id velocity_id_table[] __devinitdata = {
./drivers/net/wireless/orinoco.c:/* Can't be declared "const" or the whole __initdata section will
./drivers/net/wireless/spectrum_cs.c:/* Can't be declared "const" or the whole __initdata section will
./drivers/net/wireless/orinoco_cs.c:/* Can't be declared "const" or the whole __initdata section will
./drivers/net/starfire.c:static const char version[] __devinitdata =
./drivers/net/fealnx.c:static const struct chip_info skel_netdrv_tbl[] __devinitdata = {
./drivers/net/mlx4/main.c:static const char mlx4_version[] __devinitdata =
./drivers/net/bnx2.c:static const char version[] __devinitdata =
./drivers/net/ne3210.c:static const char *ifmap[] __initdata = {"UTP", "?", "BNC", "AUI"};
./drivers/net/tulip/eeprom.c:static const char *block_name[] __devinitdata = {
./drivers/net/tulip/winbond-840.c:static const struct pci_id_info pci_id_tbl[] __devinitdata = {
./drivers/net/sundance.c:static const struct pci_id_info pci_id_tbl[] __devinitdata = {
./drivers/net/natsemi.c:static const char version[] __devinitdata =
./drivers/net/natsemi.c:static const struct pci_device_id natsemi_pci_tbl[] __devinitdata = {
./drivers/mtd/maps/wr_sbc82xx_flash.c:static const char *part_probes[] __initdata = {"cmdlinepart", "RedBoot", NULL};
./drivers/watchdog/sbc_epx_c3.c:static const char banner[] __initdata =
./drivers/macintosh/macio_asic.c:static const struct pci_device_id __devinitdata pci_ids [] = { {
./drivers/video/gxt4500.c:static const struct fb_videomode defaultmode __devinitdata = {
./drivers/video/gxt4500.c:static const struct fb_fix_screeninfo gxt4500_fix __devinitdata = {
./drivers/video/i810/i810_main.c:static const char *i810_pci_list[] __devinitdata = {
./drivers/video/geode/lxfb_core.c:const struct fb_videomode geode_modedb[] __initdata = {
./drivers/video/geode/gx1fb_core.c:static const struct fb_videomode __initdata gx1_modedb[] = {
./drivers/video/geode/gxfb_core.c:static const struct fb_videomode gx_modedb[] __initdata = {
./drivers/video/aty/aty128fb.c:static const char *r128_family[] __devinitdata = {
./drivers/edac/amd76x_edac.c:static const struct pci_device_id amd76x_pci_tbl[] __devinitdata = {
./drivers/edac/i82975x_edac.c:static const struct pci_device_id i82975x_pci_tbl[] __devinitdata = {
./drivers/edac/i82860_edac.c:static const struct pci_device_id i82860_pci_tbl[] __devinitdata = {
./drivers/edac/e7xxx_edac.c:static const struct pci_device_id e7xxx_pci_tbl[] __devinitdata = {
./drivers/edac/i82875p_edac.c:static const struct pci_device_id i82875p_pci_tbl[] __devinitdata = {
./drivers/edac/i82443bxgx_edac.c:static const struct pci_device_id i82443bxgx_pci_tbl[] __devinitdata = {
./drivers/edac/e752x_edac.c:static const struct pci_device_id e752x_pci_tbl[] __devinitdata = {
./drivers/edac/i5000_edac.c:static const struct pci_device_id i5000_pci_tbl[] __devinitdata = {
./drivers/edac/r82600_edac.c:static const struct pci_device_id r82600_pci_tbl[] __devinitdata = {
./drivers/edac/i3000_edac.c:static const struct pci_device_id i3000_pci_tbl[] __devinitdata = {
./drivers/media/dvb/cinergyT2/cinergyT2.c:static const struct usb_device_id cinergyt2_table [] __devinitdata = {
./drivers/mmc/host/sdhci.c:static const struct pci_device_id pci_ids[] __devinitdata = {
./drivers/mmc/host/ricoh_mmc.c:static const struct pci_device_id pci_ids[] __devinitdata = {
./drivers/char/hw_random/intel-rng.c:		static __initdata /*const*/ char warning[] =
./drivers/char/mbcs.c:static const struct cx_device_id __devinitdata mbcs_id_table[] = {
./drivers/scsi/aic94xx/aic94xx_init.c:static const struct pci_device_id aic94xx_pci_table[] __devinitdata = {
./drivers/hwmon/w83627hf.c:	static const __initdata char *names[] = {
./drivers/hwmon/w83627ehf.c:	static const char __initdata sio_name_W83627EHF[] = "W83627EHF";
./drivers/hwmon/w83627ehf.c:	static const char __initdata sio_name_W83627EHG[] = "W83627EHG";
./drivers/hwmon/w83627ehf.c:	static const char __initdata sio_name_W83627DHG[] = "W83627DHG";
