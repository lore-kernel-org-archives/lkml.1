Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbZENRxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbZENRxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZENRwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:52:53 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:11065 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752976AbZENRww convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:52:52 -0400
X-BigFish: VPS-35(zz1432R98dR148cM1805M179dR1fa4L936fJ19c1l19c2kzz1202hzzz32i6bh6di43j)
X-WSS-ID: 0KJNAYN-02-HE4-01
Date: Thu, 14 May 2009 19:52:05 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: akpm@linux-foundation.org, greg@kroah.com, norsk5@yahoo.com,
       tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com, aris@redhat.com,
       edt@aei.ca, linux-kernel@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: [PATCH 21/21] amd64_edac: add module registration routines
Message-ID: <20090514175205.GB8575@aftab>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com> <1241704183-29223-22-git-send-email-borislav.petkov@amd.com> <20090507215815.GB28770@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090507215815.GB28770@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 14 May 2009 17:52:05.0853 (UTC) FILETIME=[B1CA38D0:01C9D4BC]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

thanks for so thoroughly reviewing the driver, the newest patchset will
be arriving shortly after testing is done.

On Thu, May 07, 2009 at 11:58:15PM +0200, Ingo Molnar wrote:
> 
> * Borislav Petkov <borislav.petkov@amd.com> wrote:
> 
> > +config EDAC_AMD64_OPTERON
> > +	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
> > +	depends on EDAC_MM_EDAC && X86 && PCI && NUMA
> 
> Please dont add too many depends conditions - that just reduces the 
> testing (and the utility) of the code.
> 
> Especially the dependency on NUMA seems harmful - non-NUMA kernels 
> are running on Opterons just fine. Especially when people have 
> interleaved memory and dont fancy a NUMA scheduler they might opt to 
> disable CONFIG_NUMA. EDAC support should really be orthogonal to 
> that.

I needed the NUMA dependency for for_each_online_node() in order to init
an EDAC instance per northbridge on a multi-socket system. Converted the
code to num_k8_northbridges <x86/kernel/k8.c>, which should be ok for
now.

> The CONFIG_PCI dependency is understandable :)
> 
> i'd also add a:
> 
> 	default m
> 
> As when EDAC is enabled people (and distros) generally want to 
> enable most of the sub-drivers without having to go through them.

done.

> > +	  Recent Opterons (Family 10h and later) provide for Memory Error
> > +	  Injection into the ECC detection circuits. The amd64_edac module
> > +	  allows the operator/user to inject Uncorrectable and Correctable
> > +	  errors into DRAM.
> > +
> > +	  When enabled, in each of the respective memory controller directories
> > +	  (/sys/devices/system/edac/mc/mcX), there are 3 input files:
> > +
> > +	  - z_inject_section (0..3, 16-byte section of 64-byte cacheline),
> > +	  - z_inject_word (0..8, 16-bit word of 16-byte section),
> > +	  - z_inject_bit_map (hex bitmap vector: mask bits of 16 bit word to
> > +	    error-out)
> > +
> > +	  In addition, there are two control files, z_inject_read and
> > +	  z_inject_write, which trigger the Read and Write errors respectively.
> 
> I think the file names should follow existing EDAC driver practices, 
> and be named according to the existing inject_data_* pattern?
> 
> There's nothing more annoying to users (and tools) than inconsistent 
> driver namespaces.

Agreed. Done.

@Doug: edac-utils doesn't use those yet, right?

[..]

> > +static void amd64_set_mc_sysfs_attributes(struct mem_ctl_info *mci)
> > +{
> > +	struct mcidev_sysfs_attribute terminator = { .attr = { .name = NULL } };
> > +	unsigned int i = 0, uninitialized_var(j);
> 
> i'd suggest a plain j=0. There's no performance argument here, and 
> if j _ever_ in the future becomes truly unused, we have a GCC 
> warning supressed and might face some serious bug without 
> thecompiler helping us.

done.

> > +
> > +#ifdef CONFIG_EDAC_DEBUG
> > +	for (; i < ARRAY_SIZE(amd64_dbg_attrs); i++)
> > +		sysfs_attrs[i] = amd64_dbg_attrs[i];
> > +#endif
> 
> In fact, my suggestion above to make amd64_dbg_attrs[] defined but 
> zero-size would eliminate this ifdef. So i'd suggest doing it.

Yep, zero sized array is much more elegant, thanks.

[..]

> > +
> > +	sysfs_attrs[i] = terminator;
> > +
> > +	mci->mc_driver_sysfs_attributes = sysfs_attrs;
> > +}
> > +
> > +/*
> > + * amd64_setup_mci_misc_attributes
> > + *
> > + *	initialize various attributes of the mci structure
> > + */
> > +static void amd64_setup_mci_misc_attributes(struct mem_ctl_info *mci)
> > +{
> > +	struct amd64_pvt *pvt = mci->pvt_info;
> > +
> > +	/* Initialize various states */
> > +	mci->mtype_cap = MEM_FLAG_DDR2 | MEM_FLAG_RDDR2;
> > +	mci->edac_ctl_cap = EDAC_FLAG_NONE;
> > +	mci->edac_cap = EDAC_FLAG_NONE;
> 
> Please write such 3-line or larger structure assignments as a 
> vertically spaces construct:
> 
> 	mci->mtype_cap		= MEM_FLAG_DDR2 | MEM_FLAG_RDDR2;
> 	mci->edac_ctl_cap	= EDAC_FLAG_NONE;
> 	mci->edac_cap		= EDAC_FLAG_NONE;
> 
> Note how visible the flags have become. (This form also tell us that 
> the only non-standard initialization here is for the mtype_cap 
> field. Such things help review - and can pinpoint bugs.)

fixed.

> > +	/* Exam the capabilities of the northbridge in order to reflect them
> > +	 * in the presentation via sysfs attributes, etc
> > +	 */
> 
> please use the customary comment style:
> 
>   /*
>    * Comment .....
>    * ...... goes here:
>    */
> 
> also described in Documentation/CodingStyle.
> 
> This is a continuing observation for a number of other cases where 
> you introduce half-winged comments.

done.

> > +	if (pvt->nbcap & K8_NBCAP_SECDED)
> > +		mci->edac_ctl_cap |= EDAC_FLAG_SECDED;
> > +
> > +	if (pvt->nbcap & K8_NBCAP_CHIPKILL)
> > +		mci->edac_ctl_cap |= EDAC_FLAG_S4ECD4ED;
> > +
> > +	/* What type of SECDED is there? */
> > +	mci->edac_cap = amd64_determine_edac_cap(pvt);
> > +
> > +	/* Misc attributes to set */
> > +	mci->mod_name = EDAC_MOD_STR;
> > +	mci->mod_ver = EDAC_AMD64_VERSION;
> > +	mci->ctl_name = get_amd_family_name(pvt->mc_type_index);
> > +	mci->dev_name = pci_name(pvt->dram_f2_ctl);
> > +	mci->ctl_page_to_phys = NULL;
> 
> vertical spacing probably helps here too.

done.

[..]

> > +static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl,
> > +					int mc_type_index)
> > +{
> > +	struct amd64_pvt *pvt;
> > +	int err;
> > +	int rc;
> > +
> > +	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
> > +	if (pvt == NULL) {
> > +		rc = -ENOMEM;
> > +		goto exit_now;
> > +	}
> 
> The customary pattern is:
> 
> 	ret = -ENOMEM;
> 	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
> 	if (!pvt)
> 		goto err;
> 
> Note the four differences:
> 
>  - use 'ret' instead of 'rc' for integer returns
>  - pre-initialize 'ret', not in the exception branch
>  - !pvt instead of 'pvt == NULL'
>  - use 'err*' naming for error labels

done.

> > +	pvt->mc_node_id = get_mc_node_id_from_pdev(dram_f2_ctl);
> > +
> > +	debugf0("=========== %s(Instance= %d) ===========\n",
> > +		__func__, pvt->mc_node_id);
> 
> please use something like trace_printk() instead. That will allow 
> high-performance tracing of this code, should the need arise. Also 
> 'debugf0' says nothing - what does it mean?

Yeah, those debugf0X are not that elegant but since they're not
driver-specific but pertain to the EDAC core, we should postpone fixing
those for now.

> > +
> > +	pvt->dram_f2_ctl = dram_f2_ctl;
> > +	pvt->ext_model = boot_cpu_data.x86_model >> 4;
> > +	pvt->mc_type_index = mc_type_index;
> > +	pvt->ops = get_amd_family_ops(mc_type_index);
> > +	pvt->old_mcgctl = 0;
> 
> vertical spacing please.

done and...

> Also, i'd suggest s/get_amd_family_ops/family_ops. This method is 
> local to the driver so saying that it's 'amd' is superfluous.

done.

> > +
> > +	/*
> > +	 * We have the dram_f2_ctl device as an argument, now go reserved its
> > +	 * sibling devices from the PCI system.
> > +	 */
> > +	err = amd64_reserve_mc_sibling_devices(pvt, mc_type_index);
> > +	if (err) {
> > +		rc = -ENODEV;
> > +		goto exit_now;
> > +	}
> 
> same allocation-error error pattern observation as above. It appears 
> you use it in other places as well - so please fix it everywhere.
> 
> Bug: in the error case there's now a memory leak of 'pvt'.

> > +
> > +	rc = amd64_check_ecc_enabled(pvt);
> > +	if (rc)
> > +		goto exit_release_devices;
> 
> Bug: in the error case there's now a memory leak of 'pvt'.

yep, you bet. Thanks for catching that one. Fixed.

> > +
> > +	/*
> > +	 * Key operation here: setup of HW prior to performing ops on it. Some
> > +	 * setup is required to access ECS data. After this is performed, then
> > +	 * the 'teardown' function must be called upon error and normal exit
> > +	 * paths.
> > +	 */
> > +	if (boot_cpu_data.x86 > 0xf)
> > +		amd64_setup(pvt);
> 
> You really want to write >= 0x10 here - it's the same code but tells 
> us the real story, that it's Fam10 and later. (And there's a 
> symbolic constant for Fam10.)

symbolic constant? E.g., <arch/x86/kernel/cpu/amd.c> tests F10h with bare
numbers:

...
if (c->x86 == 0x10 || c->x86 == 0x11)
...

Maybe I'm missing something, hmm?

> > +
> > +	/*
> > +	 * Save the pointer to the private data for use in 2nd initialization
> > +	 * stage
> > +	 */
> > +	pvt_lookup[pvt->mc_node_id] = pvt;
> > +
> > +	debugf0("%s(): init 1st stage done pvt-%d\n", __func__,
> > +		pvt->mc_node_id);
> > +	return 0;
> > +
> > +
> > +exit_release_devices:
> > +	pci_dev_put(pvt->addr_f1_ctl);
> > +	pci_dev_put(pvt->misc_f3_ctl);
> 
> this teardown is correct but a bit unclean: it open-codes the 
> reverse direction of:
> 
> 	err = amd64_reserve_mc_sibling_devices(pvt, mc_type_index);
> 
> It would be better to add a amd64_free_mc_sibling_devices(pvt) 
> method.

done.
 
> > +
> > +exit_now:
> > +	return rc;
> > +}
> > +
> > +/*
> > + * amd64_init_2nd_stage
> > + *
> > + *	this is the "finishing" up initialization code
> > + *	Needs to be performed after all MCs' Hardware have been
> > + *	"prep'ed" for accessing extended config space.
> > + */
> > +static int amd64_init_2nd_stage(struct amd64_pvt *pvt_temp)
> > +{
> > +	int node_id = pvt_temp->mc_node_id;
> > +	struct mem_ctl_info *mci;
> > +	struct amd64_pvt *pvt;
> > +	int rc;
> > +	int err;
> > +
> > +	debugf0("%s()\n", __func__);
> > +
> > +	amd64_read_mc_registers(pvt_temp);
> > +
> > +	/* Check hardware to see if this module can support HW at this time */
> > +	if (pvt_temp->ops->probe_valid_hardware) {
> > +		err = pvt_temp->ops->probe_valid_hardware(pvt_temp);
> > +		if (err) {
> > +			rc = -ENODEV;
> > +			goto exit_failure;
> > +		}
> 
> error handling pattern.

done.

> > +	}
> > +
> > +	/*
> > +	 * We need to determine how many memory channels there are. Then use
> > +	 * that information for calculating the size of the dynamic instance
> > +	 * tables in the 'mci' structure
> > +	 */
> > +	pvt_temp->channel_count = pvt_temp->ops->early_channel_count(pvt_temp);
> > +
> > +	mci = edac_mc_alloc(sizeof(*pvt_temp),
> > +				CHIPSELECT_COUNT,
> > +				pvt_temp->channel_count,
> > +				node_id);
> > +	if (mci == NULL) {
> > +		rc = -ENOMEM;
> > +		goto exit_failure;
> > +	}
> 
> ditto.
> 

done.

> > +
> > +	/*
> > +	 * transfer the info from the interium pvt area to the private area of
> > +	 * the MC instance structure
> > +	 */
> > +	pvt = mci->pvt_info;
> > +	*pvt = *pvt_temp;
> 
> hm, such copying can be dangerous. If pvt_temp ever grows something 
> like a list_head, then the copy can corrupt the list. Could this be 
> avoided?

Well, this design is not really kernel-y. From the top of my head, we
could bypass the EDAC core' mc_alloc and use the void *pvt_info the way
it is done in the zillion other drivers - pointer to private data and
alloc that amd64_pvt dynamically in the driver, thus alleviating the
copy...

done.

> > +
> > +	mci->dev = &pvt_temp->dram_f2_ctl->dev;
> > +	amd64_setup_mci_misc_attributes(mci);
> > +
> > +	if (amd64_init_csrows(mci)) {
> > +		debugf1("Setting mci->edac_cap to EDAC_FLAG_NONE because\n");
> > +		debugf1("   amd64_init_csrows() returned NO csrows found\n");
> > +		mci->edac_cap = EDAC_FLAG_NONE;
> > +	}
> > +
> > +	amd64_enable_ecc_error_reporting(mci);
> > +	amd64_set_mc_sysfs_attributes(mci);
> > +
> > +	if (edac_mc_add_mc(mci)) {
> > +		debugf1("%s(): failed edac_mc_add_mc()\n", __func__);
> > +		rc = -ENODEV;
> > +		goto exit_add_mc_failure;
> > +	}
> > +
> > +	debugf0("%s(): init 2nd stage done mci%d\n", __func__,
> > +		pvt->mc_node_id);
> > +
> > +	mci_lookup[node_id] = mci;
> > +
> > +	kfree(pvt_lookup[pvt->mc_node_id]);
> > +	pvt_lookup[node_id] = NULL;
> > +	return 0;
> > +
> > +exit_add_mc_failure:
> > +	edac_mc_free(mci);
> > +
> > +exit_failure:
> > +	debugf0("%s() failure init 2nd stage: rc=%d\n", __func__, rc);
> > +
> > +	amd64_restore_ecc_error_reporting(pvt);
> > +
> > +	if (boot_cpu_data.x86 > 0xf)
> > +		amd64_teardown(pvt);
> > +
> > +	pci_dev_put(pvt->addr_f1_ctl);
> > +	pci_dev_put(pvt->misc_f3_ctl);
> 
> this too is a teardown open-coding assymetry.

done

> > +
> > +	kfree(pvt_lookup[pvt->mc_node_id]);
> > +	pvt_lookup[node_id] = NULL;
> > +
> > +	return rc;
> > +}
> > +
> > +
> > +/*
> > + * amd64_init_one_instance
> > + *
> > + *	initialize just one device
> > + *
> > + *	returns:
> > + *		 count (>= 0), or
> > + *		negative on error
> > + */
> > +static int __devinit amd64_init_one_instance(struct pci_dev *pdev,
> > +				 const struct pci_device_id *mc_type)
> > +{
> > +	int rc;
> > +
> > +	debugf0("%s(MC node=%d,mc_type='%s')\n",
> > +		__func__,
> > +		get_mc_node_id_from_pdev(pdev),
> > +		get_amd_family_name(mc_type->driver_data));
> > +
> > +	/* wake up and enable device */
> > +	rc = pci_enable_device(pdev);
> > +	if (rc < 0)
> > +		rc = -EIO;
> > +	else
> > +		rc = amd64_probe_one_instance(pdev, mc_type->driver_data);
> > +
> > +	if (rc < 0)
> > +		debugf0("%s() rc=%d\n", __func__, rc);
> 
> there's way too many debugf*() calls in the whole code, often 
> obscuring the real structure. I think we'll be far better off with 
> having just a few key ones.

Cleaning up... done. I was able to remove some of the dbg calls which I
thought are not needed. I'd suggest we have a second stab at that after
development settles, as we might still need the occasional dbg call here
and there.

> > +
> > +	return rc;
> > +}
> > +
> > +/*
> > + * amd64_remove_one_instance
> > + *
> > + *	remove just one device instance upon driver unloading
> > + */
> > +static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
> > +{
> > +	struct mem_ctl_info *mci;
> > +	struct amd64_pvt *pvt;
> > +
> > +	debugf0("%s()\n", __func__);
> > +
> > +	/* Remove from EDAC CORE tracking list */
> > +	mci = edac_mc_del_mc(&pdev->dev);
> > +	if (mci == NULL)
> > +		return;
> > +
> > +	pvt = mci->pvt_info;
> > +
> > +	amd64_restore_ecc_error_reporting(pvt);
> > +
> > +	if (boot_cpu_data.x86 > 0xf)
> > +		amd64_teardown(pvt);
> > +
> > +	pci_dev_put(pvt->addr_f1_ctl);
> > +	pci_dev_put(pvt->misc_f3_ctl);
> > +
> > +	mci_lookup[pvt->mc_node_id] = NULL;
> > +
> > +	/* Free the EDAC CORE resources */
> > +	edac_mc_free(mci);
> > +}
> > +
> > +/*
> > + * The 'pci_device_id' table.
> > + *
> > + *	This table is part of the interface for loading drivers for PCI
> > + *	devices. The PCI core identifies what devices are on a system
> > + *	during boot, and then inquiry this table to see if this driver
> > + *	is for a given device found.
> > + *
> > + *	The PCI helpper functions walk this table and call the
> > + *	'.probe' function of the 'pci_driver' table, for each
> > + *	instance in this table
> > + */
> > +static const struct pci_device_id amd64_pci_table[] __devinitdata = {
> > +	{
> > +		/* Rev F and prior */
> > +		.vendor = PCI_VENDOR_ID_AMD,
> > +		.device = PCI_DEVICE_ID_AMD_K8_NB_MEMCTL,
> > +		.subvendor = PCI_ANY_ID,
> > +		.subdevice = PCI_ANY_ID,
> > +		.class = 0,
> > +		.class_mask = 0,
> > +		.driver_data = K8_CPUS
> 
> these initializers benefit from vertical spacing too:
> 
> 		.vendor		= PCI_VENDOR_ID_AMD,
> 		.device		= PCI_DEVICE_ID_AMD_K8_NB_MEMCTL,
> 		.subvendor	= PCI_ANY_ID,
> 		.subdevice	= PCI_ANY_ID,
> 		.class		= 0,
> 		.class_mask	= 0,
> 		.driver_data	= K8_CPUS
> 
> It is elegant and readable at a glance.

done

> > +	},
> > +	{
> > +		/* Family 10h */
> > +		.vendor = PCI_VENDOR_ID_AMD,
> > +		.device = PCI_DEVICE_ID_AMD_10H_NB_DRAM,
> > +		.subvendor = PCI_ANY_ID,
> > +		.subdevice = PCI_ANY_ID,
> > +		.class = 0,
> > +		.class_mask = 0,
> > +		.driver_data = F10_CPUS
> > +	},
> > +	{
> > +		/* Family 11h */
> > +		.vendor = PCI_VENDOR_ID_AMD,
> > +		.device = PCI_DEVICE_ID_AMD_11H_NB_DRAM,
> > +		.subvendor = PCI_ANY_ID,
> > +		.subdevice = PCI_ANY_ID,
> > +		.class = 0,
> > +		.class_mask = 0,
> > +		.driver_data = F11_CPUS
> > +	},
> > +	{0, }
> > +};
> > +MODULE_DEVICE_TABLE(pci, amd64_pci_table);
> > +
> > +/*
> > + * The 'pci_driver' structure to define the name, probe and removal
> > + * functions
> > + */
> > +static struct pci_driver amd64_pci_driver = {
> > +	.name = EDAC_MOD_STR,
> > +	.probe = amd64_init_one_instance,
> > +	.remove = __devexit_p(amd64_remove_one_instance),
> > +	.id_table = amd64_pci_table,
> 
> ditto.

done.

> > +};
> > +
> > +
> > +/*
> > + * amd64_setup_pci_device
> > + *
> > + *	setup the PCI Device Driver for monitoring PCI errors
> > + */
> > +static void amd64_setup_pci_device(void)
> > +{
> > +	struct mem_ctl_info *mci;
> > +	struct amd64_pvt *pvt;
> > +
> > +	if (!amd64_ctl_pci) {
> 
> this branch goes on:
> 
> > +
> > +		mci = mci_lookup[0];
> > +		if (mci) {
> > +			debugf1("%s(): Registering ONE PCI control\n",
> > +				__func__);
> 
> and on:
> 
> > +
> > +			pvt = mci->pvt_info;
> > +			amd64_ctl_pci = edac_pci_create_generic_ctl(
> > +						&pvt->dram_f2_ctl->dev,
> > +						EDAC_MOD_STR);
> > +			if (!amd64_ctl_pci) {
> 
> and on:
> 
> > +				printk(KERN_WARNING
> > +					"%s(): Unable to create PCI control\n",
> > +					__func__);
> 
> And here you have too many tabs (five of them), that break up that 
> printk in an ugly way.
> 
> The better solution is to realize that the branch could be inverted 
> and a full level of indentation won by doing:
> 
> 	if (amd64_ctl_pci)
> 		return;
> 
> And winning another level of indentation later on by doing:
> 
> 	if (mci) {
> 		debugf1("%s(): ONE PCI control already registered\n",
> 				__func__);
> 		return;
> 	}

done and...

> Btw., please change all instances of:
> 
>    printk(KERN_WARNING,       => pr_warning(
>    printk(KERN_INFO,          => pr_info(
> 
> etc.

done.

> > +				printk(KERN_WARNING
> > +					"%s(): PCI error report via EDAC "
> > +					"not setup\n",
> > +					__func__);
> > +			}
> > +		} else {
> > +			debugf1("%s(): ONE PCI control already registered\n",
> > +				__func__);
> > +		}
> > +	}
> > +}
> > +
> > +static int __init amd64_edac_init(void)
> > +{
> > +	int err;
> > +	int node;
> > +
> > +	edac_printk(KERN_INFO, EDAC_MOD_STR, EDAC_AMD64_VERSION "\n");
> > +
> > +	opstate_init();
> > +
> > +	debugf0("%s() ******************  ENTRY  **********************\n",
> > +		__func__);
> 
> 
> if you want a debug facility, please shorten it to something like:
> 
> 	dbg(" **** ENTRY ****\n")
> 
> and make the printing of __func__ implicit in the dbg() method.  
> This will shorten these things quite a bit. But please get rid of 
> most of them - there's no excuse for having such things in the 
> kernel beyond the first 1-2 days of the development of this 
> function.

Even better, this dbg call got killed instead.

[..]

> > +
> > +	/* if no error occurred on first pass init, then do 2nd pass init */
> > +	if (!err) {
> 
> Again, by doing:
> 
> 	if (err)
> 		goto err;
> 
> You can save an identation level below, and avoid line-wrap 
> artifacts. 

Yep, thanks. Looks much more readable now.

> > +		for_each_online_node(node) {
> > +			if (!pvt_lookup[node])
> > +				continue;
> > +
> > +			/* If any failure then need to clean up */
> > +			err = amd64_init_2nd_stage(pvt_lookup[node]);
> > +			if (err) {
> > +				debugf0("%s() 'finish_setup' stage failed\n",
> > +					__func__);
> > +
> > +				/* undo prior instances' registrations
> > +				 * and leave as failed
> > +				 */
> > +				pci_unregister_driver(&amd64_pci_driver);
> > +				goto error_exit;
> > +			}
> > +		}
> > +		amd64_setup_pci_device();
> > +	}
> > +
> > +error_exit:
> > +	return err;
> > +}
> > +
> > +static void __exit amd64_edac_exit(void)
> > +{
> > +	if (amd64_ctl_pci)
> > +		edac_pci_release_generic_ctl(amd64_ctl_pci);
> > +
> > +	pci_unregister_driver(&amd64_pci_driver);
> > +}
> > +
> > +module_init(amd64_edac_init);
> > +module_exit(amd64_edac_exit);
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("SoftwareBitMaker: Doug Thompson, "
> > +		"Dave Peterson, Thayne Harbaugh");
> > +MODULE_DESCRIPTION("MC support for AMD64 memory controllers - "
> > +		EDAC_AMD64_VERSION);
> > +
> > +module_param(edac_op_state, int, 0444);
> > +MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
> > diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
> > index d435ace..a3603f7 100644
> > --- a/drivers/edac/amd64_edac.h
> > +++ b/drivers/edac/amd64_edac.h
> > @@ -891,6 +891,11 @@ extern const char *ii_msgs[4];
> >  extern const char *ext_msgs[32];
> >  extern const char *htlink_msgs[8];
> >  
> > +#define NUM_DBG_ATTRS  9
> > +#define NUM_INJ_ATTRS  5
> > +extern struct mcidev_sysfs_attribute amd64_dbg_attrs[NUM_DBG_ATTRS],
> > +				     amd64_inj_attrs[NUM_INJ_ATTRS];
> > +
> >  /*
> >   * Each of the PCI Device IDs types have their own set of hardware
> >   * accessor function and per device encoding/decoding logic.
> > diff --git a/drivers/edac/amd64_edac_dbg.c b/drivers/edac/amd64_edac_dbg.c
> > index 3741af9..f538129 100644
> > --- a/drivers/edac/amd64_edac_dbg.c
> > +++ b/drivers/edac/amd64_edac_dbg.c
> > @@ -211,6 +211,9 @@ static ssize_t amd64_hole_show(struct mem_ctl_info *mci, char *data)
> >  						 hole_size);
> >  }
> >  
> > +/*
> > + * update NUM_DBG_ATTRS in case you add new members
> > + */
> >  struct mcidev_sysfs_attribute amd64_dbg_attrs[] = {
> >  
> >  	{
> > diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
> > index 7f978cb..8706954 100644
> > --- a/drivers/edac/amd64_edac_inj.c
> > +++ b/drivers/edac/amd64_edac_inj.c
> > @@ -155,6 +155,9 @@ static ssize_t amd64_inject_write_store(struct mem_ctl_info *mci,
> >  	return 0;
> >  }
> >  
> > +/*
> > + * update NUM_INJ_ATTRS in case you add new members
> > + */
> >  struct mcidev_sysfs_attribute amd64_inj_attrs[] = {
> >  
> >  	{
> 
> Looks like these fixlets dont really belong in this patch and should 
> either be backmerged or put into a separate patch?

Done.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

