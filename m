Return-Path: <linux-kernel-owner+w=401wt.eu-S1762800AbZJOP1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762800AbZJOP1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762217AbZJOP1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:27:04 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55366 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253AbZJOP1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:27:02 -0400
Message-ID: <4AD73E83.7010908@austin.ibm.com>
Date: Thu, 15 Oct 2009 10:23:47 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5 v3] kernel handling of memory DLPAR
References: <4AB39FB3.1020608@austin.ibm.com>	 <4AB3A13D.1060405@austin.ibm.com>  <4AD4C346.20801@austin.ibm.com> <1255473061.21871.40.camel@concordia>
In-Reply-To: <1255473061.21871.40.camel@concordia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman wrote:
> On Tue, 2009-10-13 at 13:13 -0500, Nathan Fontenot wrote:
>> This adds the capability to DLPAR add and remove memory from the kernel.  The
> 
> Hi Nathan,
> 
> Sorry to only get around to reviewing version 3, time is a commodity in
> short supply :)
> 
>> Index: powerpc/arch/powerpc/platforms/pseries/dlpar.c
>> ===================================================================
>> --- powerpc.orig/arch/powerpc/platforms/pseries/dlpar.c	2009-10-08 11:08:42.000000000 -0500
>> +++ powerpc/arch/powerpc/platforms/pseries/dlpar.c	2009-10-13 13:08:22.000000000 -0500
>> @@ -16,6 +16,10 @@
>>  #include <linux/notifier.h>
>>  #include <linux/proc_fs.h>
>>  #include <linux/spinlock.h>
>> +#include <linux/memory_hotplug.h>
>> +#include <linux/sysdev.h>
>> +#include <linux/sysfs.h>
>> +
>>  
>>  #include <asm/prom.h>
>>  #include <asm/machdep.h>
>> @@ -404,11 +408,165 @@
>>  	return 0;
>>  }
>>  
>> +#ifdef CONFIG_MEMORY_HOTPLUG
>> +
>> +static struct property *clone_property(struct property *old_prop)
>> +{
>> +	struct property *new_prop;
>> +
>> +	new_prop = kzalloc((sizeof *new_prop), GFP_KERNEL);
>> +	if (!new_prop)
>> +		return NULL;
>> +
>> +	new_prop->name = kzalloc(strlen(old_prop->name) + 1, GFP_KERNEL);
> 
> kstrdup()?

Ahhh.. I did not know of kstrdup().  I will update to use this instead.

> 
>> +	new_prop->value = kzalloc(old_prop->length + 1, GFP_KERNEL);
>> +	if (!new_prop->name || !new_prop->value) {
>> +		free_property(new_prop);
>> +		return NULL;
>> +	}
>> +
>> +	strcpy(new_prop->name, old_prop->name);
>> +	memcpy(new_prop->value, old_prop->value, old_prop->length);
>> +	new_prop->length = old_prop->length;
>> +
>> +	return new_prop;
>> +}
>> +
>> +int platform_probe_memory(u64 phys_addr)
>> +{
>> +	struct device_node *dn;
>> +	struct property *new_prop, *old_prop;
>> +	struct property *lmb_sz_prop;
>> +	struct of_drconf_cell *drmem;
>> +	u64 lmb_size;
>> +	int num_entries, i, rc;
>> +
>> +	if (!phys_addr)
>> +		return -EINVAL;
>> +
>> +	dn = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
>> +	if (!dn)
>> +		return -EINVAL;
>> +
>> +	lmb_sz_prop = of_find_property(dn, "ibm,lmb-size", NULL);
>> +	lmb_size = *(u64 *)lmb_sz_prop->value;
> 
> of_get_property() ?

ok, will switch to of_find_property()

>> +
>> +	old_prop = of_find_property(dn, "ibm,dynamic-memory", NULL);
> 
> I know we should never fail to find these properties, but it would be
> nice to check just in case.
> 

yes, will update.

>> +
>> +	num_entries = *(u32 *)old_prop->value;
>> +	drmem = (struct of_drconf_cell *)
>> +				((char *)old_prop->value + sizeof(u32));
> 
> You do this dance twice (see below), a struct might make it cleaner.

Agreed.  I think I will make this update in a separate patch.  Updating
this to use a of_drconf struct would benefit this code as well as the code
in powerpc/numa.c that also deals with manipulating this property.

> 
>> +	for (i = 0; i < num_entries; i++) {
>> +		u64 lmb_end_addr = drmem[i].base_addr + lmb_size;
>> +		if (phys_addr >= drmem[i].base_addr
>> +		    && phys_addr < lmb_end_addr)
>> +			break;
>> +	}
>> +
>> +	if (i >= num_entries) {
>> +		of_node_put(dn);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (drmem[i].flags & DRCONF_MEM_ASSIGNED) {
>> +		of_node_put(dn);
>> +		return 0;
> 
> This is the already added case?

Yes.  In this case the lmb is already assigned to the system.

> 
>> +	}
>> +
>> +	rc = acquire_drc(drmem[i].drc_index);
>> +	if (rc) {
>> +		of_node_put(dn);
>> +		return -1;
> 
> -1 ?

Yeah, bad choice.

> 
>> +	}
>> +
>> +	new_prop = clone_property(old_prop);
>> +	drmem = (struct of_drconf_cell *)
>> +				((char *)new_prop->value + sizeof(u32));
>> +
>> +	drmem[i].flags |= DRCONF_MEM_ASSIGNED;
>> +	prom_update_property(dn, new_prop, old_prop);
>> +
>> +	rc = blocking_notifier_call_chain(&pSeries_reconfig_chain,
>> +					  PSERIES_DRCONF_MEM_ADD,
>> +					  &drmem[i].base_addr);
>> +	if (rc == NOTIFY_BAD) {
>> +		prom_update_property(dn, old_prop, new_prop);
>> +		release_drc(drmem[i].drc_index);
>> +	}
>> +
>> +	of_node_put(dn);
>> +	return rc == NOTIFY_BAD ? -1 : 0;
> 
> -1 ?

Another bad return code choice.

> 
>> +}
>> +
>> +static ssize_t memory_release_store(struct class *class, const char *buf,
>> +				    size_t count)
>> +{
>> +	unsigned long drc_index;
>> +	struct device_node *dn;
>> +	struct property *new_prop, *old_prop;
>> +	struct of_drconf_cell *drmem;
>> +	int num_entries;
>> +	int i, rc;
>> +
>> +	rc = strict_strtoul(buf, 0, &drc_index);
>> +	if (rc)
>> +		return -EINVAL;
>> +
>> +	dn = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
>> +	if (!dn)
>> +		return 0;
> 
> 0 really?

... and again...

> 
>> +
>> +	old_prop = of_find_property(dn, "ibm,dynamic-memory", NULL);
>> +	new_prop = clone_property(old_prop);
>> +
>> +	num_entries = *(u32 *)new_prop->value;
>> +	drmem = (struct of_drconf_cell *)
>> +				((char *)new_prop->value + sizeof(u32));
>> +
>> +	for (i = 0; i < num_entries; i++) {
>> +		if (drmem[i].drc_index == drc_index)
>> +			break;
>> +	}
>> +
>> +	if (i >= num_entries) {
>> +		free_property(new_prop);
>> +		of_node_put(dn);
>> +		return -EINVAL;
>> +	}
> 
> Couldn't use old_prop up until here? They're identical aren't they, so
> you can do the clone here and you can avoid the free in the above error
> case.
> 

Yes, this is possible.  I will clean this up.

>> +	drmem[i].flags &= ~DRCONF_MEM_ASSIGNED;
>> +	prom_update_property(dn, new_prop, old_prop);
>> +
>> +	rc = blocking_notifier_call_chain(&pSeries_reconfig_chain,
>> +					  PSERIES_DRCONF_MEM_REMOVE,
>> +					  &drmem[i].base_addr);
>> +	if (rc != NOTIFY_BAD)
>> +		rc = release_drc(drc_index);
>> +
>> +	if (rc)
>> +		prom_update_property(dn, old_prop, new_prop);
>> +
>> +	of_node_put(dn);
>> +	return rc ? -1 : count;
> 
> -1, EPERM?

EPERM.

> 
>> +}
>> +
>> +static struct class_attribute class_attr_mem_release =
>> +			__ATTR(release, S_IWUSR, NULL, memory_release_store);
>> +#endif
>> +
>>  static int pseries_dlpar_init(void)
>>  {
>>  	if (!machine_is(pseries))
>>  		return 0;
>>  
>> +#ifdef CONFIG_MEMORY_HOTPLUG
>> +	if (sysfs_create_file(&memory_sysdev_class.kset.kobj,
>> +			      &class_attr_mem_release.attr))
>> +		printk(KERN_INFO "DLPAR: Could not create sysfs memory "
>> +		       "release file\n");
>> +#endif
>> +
>>  	return 0;
>>  }
>>  device_initcall(pseries_dlpar_init);
>> Index: powerpc/arch/powerpc/mm/mem.c
>> ===================================================================
>> --- powerpc.orig/arch/powerpc/mm/mem.c	2009-10-08 11:07:45.000000000 -0500
>> +++ powerpc/arch/powerpc/mm/mem.c	2009-10-08 11:08:54.000000000 -0500
>> @@ -111,8 +111,19 @@
>>  #ifdef CONFIG_MEMORY_HOTPLUG
>>  
>>  #ifdef CONFIG_NUMA
>> +int __attribute ((weak)) platform_probe_memory(u64 start)
> 
> __weak
> 
> Though be careful, I think this is vulnerable to a bug in some
> toolchains where the compiler will inline this version. See the comment
> around early_irq_init() in kernel/softirq.c for example.
> 
> This will need to be a ppc_md hook as soon as another platform supports
> memory hotplug, though that may be never :)
> 

I didn't know any other way to implement this.  If using a weak symbol is ok
I will leave it.  I am open to suggestions if there is a better way to do this.

thanks for reviewing the patch.

-Nathan

>> +{
>> +	return 0;
>> +}
>> +
>>  int memory_add_physaddr_to_nid(u64 start)
>>  {
>> +	int rc;
>> +
>> +	rc = platform_probe_memory(start);
>> +	if (rc)
>> +		return rc;
>> +
>>  	return hot_add_scn_to_nid(start);
>>  }
>>  #endif
> 
> cheers
> 
