Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbZJ2DK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbZJ2DK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 23:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZJ2DK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 23:10:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:41675 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbZJ2DK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 23:10:57 -0400
Subject: Re: [PATCH 1/6 v5] Kernel DLPAR Infrastructure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4AE8AF4D.4030403@austin.ibm.com>
References: <4AE8ADCF.6090104@austin.ibm.com>
	 <4AE8AF4D.4030403@austin.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Oct 2009 14:08:51 +1100
Message-ID: <1256785731.26770.38.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 15:53 -0500, Nathan Fontenot wrote:
> This patch provides the kernel DLPAR infrastructure in a new filed named
> dlpar.c.  The functionality provided is for acquiring and releasing a resource
> from firmware and the parsing of information returned from the
> ibm,configure-connector rtas call.  Additionally this exports the pSeries
> reconfiguration notifier chain so that it can be invoked when device tree 
> updates are made.
> 
> Signed-off-by: Nathan Fontenot <nfont at austin.ibm.com> 
> ---

Hi Nathan !

Finally I get to review this stuff :-)

> +#define CFG_CONN_WORK_SIZE	4096
> +static char workarea[CFG_CONN_WORK_SIZE];
> +static DEFINE_SPINLOCK(workarea_lock);

So I'm not a huge fan of this workarea static. First a static is in
effect a global name (as far as System.map etc... are concerned) so it
would warrant a better name. Then, do we really want that 4K of BSS
taken even on platforms that don't do dlpar ? Any reason why you don't
just pop a free page with __get_free_page() inside of
configure_connector() ?

> +struct cc_workarea {
> +	u32	drc_index;
> +	u32	zero;
> +	u32	name_offset;
> +	u32	prop_length;
> +	u32	prop_offset;
> +};
> +
> +static struct property *parse_cc_property(char *workarea)
> +{
> +	struct property *prop;
> +	struct cc_workarea *ccwa;
> +	char *name;
> +	char *value;
> +
> +	prop = kzalloc(sizeof(*prop), GFP_KERNEL);
> +	if (!prop)
> +		return NULL;
> +
> +	ccwa = (struct cc_workarea *)workarea;
> +	name = workarea + ccwa->name_offset;
> +	prop->name = kzalloc(strlen(name) + 1, GFP_KERNEL);
> +	if (!prop->name) {
> +		kfree(prop);
> +		return NULL;
> +	}
> +
> +	strcpy(prop->name, name);
> +
> +	prop->length = ccwa->prop_length;
> +	value = workarea + ccwa->prop_offset;
> +	prop->value = kzalloc(prop->length, GFP_KERNEL);
> +	if (!prop->value) {
> +		kfree(prop->name);
> +		kfree(prop);
> +		return NULL;
> +	}
> +
> +	memcpy(prop->value, value, prop->length);
> +	return prop;
> +}
> +
> +static void free_property(struct property *prop)
> +{
> +	kfree(prop->name);
> +	kfree(prop->value);
> +	kfree(prop);
> +}
> +
> +static struct device_node *parse_cc_node(char *work_area)
> +{

const char* maybe ?

> +	struct device_node *dn;
> +	struct cc_workarea *ccwa;
> +	char *name;
> +
> +	dn = kzalloc(sizeof(*dn), GFP_KERNEL);
> +	if (!dn)
> +		return NULL;
> +
> +	ccwa = (struct cc_workarea *)work_area;
> +	name = work_area + ccwa->name_offset;

I'm wondering whether work_area should be a struct cc_workarea * in the
first place with a char data[] at the end, but that would mean probably
tweaking the offsets... no big deal, up to you.

> +	dn->full_name = kzalloc(strlen(name) + 1, GFP_KERNEL);
> +	if (!dn->full_name) {
> +		kfree(dn);
> +		return NULL;
> +	}
> +
> +	strcpy(dn->full_name, name);

kstrdup ?

 .../...

> +#define NEXT_SIBLING    1
> +#define NEXT_CHILD      2
> +#define NEXT_PROPERTY   3
> +#define PREV_PARENT     4
> +#define MORE_MEMORY     5
> +#define CALL_AGAIN	-2
> +#define ERR_CFG_USE     -9003
> +
> +struct device_node *configure_connector(u32 drc_index)
> +{

It's a global exported function, I'd rather you call it
dlpar_configure_connector()

> +	struct device_node *dn;
> +	struct device_node *first_dn = NULL;
> +	struct device_node *last_dn = NULL;
> +	struct property *property;
> +	struct property *last_property = NULL;
> +	struct cc_workarea *ccwa;
> +	int cc_token;
> +	int rc;
> +
> +	cc_token = rtas_token("ibm,configure-connector");
> +	if (cc_token == RTAS_UNKNOWN_SERVICE)
> +		return NULL;
> +
> +	spin_lock(&workarea_lock);
> +
> +	ccwa = (struct cc_workarea *)&workarea[0];
> +	ccwa->drc_index = drc_index;
> +	ccwa->zero = 0;

Popping a free page with gfp (or just kmalloc'ing 4K) would avoid the
need for the lock too.

> +	rc = rtas_call(cc_token, 2, 1, NULL, workarea, NULL);
> +	while (rc) {
> +		switch (rc) {
> +		case NEXT_SIBLING:
> +			dn = parse_cc_node(workarea);
> +			if (!dn)
> +				goto cc_error;
> +
> +			dn->parent = last_dn->parent;
> +			last_dn->sibling = dn;
> +			last_dn = dn;
> +			break;
> +
> +		case NEXT_CHILD:
> +			dn = parse_cc_node(workarea);
> +			if (!dn)
> +				goto cc_error;
> +
> +			if (!first_dn)
> +				first_dn = dn;
> +			else {
> +				dn->parent = last_dn;
> +				if (last_dn)
> +					last_dn->child = dn;
> +			}
> +
> +			last_dn = dn;
> +			break;
> +
> +		case NEXT_PROPERTY:
> +			property = parse_cc_property(workarea);
> +			if (!property)
> +				goto cc_error;
> +
> +			if (!last_dn->properties)
> +				last_dn->properties = property;
> +			else
> +				last_property->next = property;
> +
> +			last_property = property;
> +			break;
> +
> +		case PREV_PARENT:
> +			last_dn = last_dn->parent;
> +			break;
> +
> +		case CALL_AGAIN:
> +			break;
> +
> +		case MORE_MEMORY:
> +		case ERR_CFG_USE:
> +		default:
> +			printk(KERN_ERR "Unexpected Error (%d) "
> +			       "returned from configure-connector\n", rc);
> +			goto cc_error;
> +		}
> +
> +		rc = rtas_call(cc_token, 2, 1, NULL, workarea, NULL);
> +	}
> +
> +	spin_unlock(&workarea_lock);
> +	return first_dn;
> +
> +cc_error:
> +	spin_unlock(&workarea_lock);
> +
> +	if (first_dn)
> +		free_cc_nodes(first_dn);
> +
> +	return NULL;
> +}
> +
> +static struct device_node *derive_parent(const char *path)
> +{
> +	struct device_node *parent;
> +	char parent_path[128];
> +	int parent_path_len;
> +
> +	parent_path_len = strrchr(path, '/') - path + 1;
> +	strlcpy(parent_path, path, parent_path_len);
> +
> +	parent = of_find_node_by_path(parent_path);
> +
> +	return parent;
> +}

This ...

> +static int add_one_node(struct device_node *dn)
> +{
> +	struct proc_dir_entry *ent;
> +	int rc;
> +
> +	of_node_set_flag(dn, OF_DYNAMIC);
> +	kref_init(&dn->kref);
> +	dn->parent = derive_parent(dn->full_name);
> +
> +	rc = blocking_notifier_call_chain(&pSeries_reconfig_chain,
> +					  PSERIES_RECONFIG_ADD, dn);
> +	if (rc == NOTIFY_BAD) {
> +		printk(KERN_ERR "Failed to add device node %s\n",
> +		       dn->full_name);
> +		return -ENOMEM; /* For now, safe to assume kmalloc failure */
> +	}
> +
> +	of_attach_node(dn);
> +
> +#ifdef CONFIG_PROC_DEVICETREE
> +	ent = proc_mkdir(strrchr(dn->full_name, '/') + 1, dn->parent->pde);
> +	if (ent)
> +		proc_device_tree_add_node(dn, ent);
> +#endif
> +
> +	of_node_put(dn->parent);
> +	return 0;
> +}

 ... and this ...

> +int add_device_tree_nodes(struct device_node *dn)
> +{
> +	struct device_node *child = dn->child;
> +	struct device_node *sibling = dn->sibling;
> +	int rc;
> +
> +	dn->child = NULL;
> +	dn->sibling = NULL;
> +	dn->parent = NULL;
> +
> +	rc = add_one_node(dn);
> +	if (rc)
> +		return rc;
> +
> +	if (child) {
> +		rc = add_device_tree_nodes(child);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	if (sibling)
> +		rc = add_device_tree_nodes(sibling);
> +
> +	return rc;
> +}

 ... and this ...

> +static int remove_one_node(struct device_node *dn)
> +{
> +	struct device_node *parent = dn->parent;
> +	struct property *prop = dn->properties;
> +
> +#ifdef CONFIG_PROC_DEVICETREE
> +	while (prop) {
> +		remove_proc_entry(prop->name, dn->pde);
> +		prop = prop->next;
> +	}
> +
> +	if (dn->pde)
> +		remove_proc_entry(dn->pde->name, parent->pde);
> +#endif
> +
> +	blocking_notifier_call_chain(&pSeries_reconfig_chain,
> +			    PSERIES_RECONFIG_REMOVE, dn);
> +	of_detach_node(dn);
> +	of_node_put(dn); /* Must decrement the refcount */
> +
> +	return 0;
> +}

 ... and this ...

> +static int _remove_device_tree_nodes(struct device_node *dn)
> +{
> +	int rc;
> +
> +	if (dn->child) {
> +		rc = _remove_device_tree_nodes(dn->child);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	if (dn->sibling) {
> +		rc = _remove_device_tree_nodes(dn->sibling);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	rc = remove_one_node(dn);
> +	return rc;
> +}

 ... repeat myself ...

> +int remove_device_tree_nodes(struct device_node *dn)
> +{
> +	int rc;
> +
> +	if (dn->child) {
> +		rc = _remove_device_tree_nodes(dn->child);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	rc = remove_one_node(dn);
> +	return rc;
> +}

 ... should probably all go to something like drivers/of/dynamic.c or at
least for now arch/powerpc/kernel/of_dynamic.c along with everything
related to dynamically adding and removing nodes. I see that potentially
useful for more than just DLPAR (though DLPAR is the only user right
now) and should also all be prefixed with of_*

> +#define DR_ENTITY_SENSE		9003
> +#define DR_ENTITY_PRESENT	1
> +#define DR_ENTITY_UNUSABLE	2
> +#define ALLOCATION_STATE	9003
> +#define ALLOC_UNUSABLE		0
> +#define ALLOC_USABLE		1
> +#define ISOLATION_STATE		9001
> +#define ISOLATE			0
> +#define UNISOLATE		1
> +
> +int acquire_drc(u32 drc_index)
> +{
> +	int dr_status, rc;
> +
> +	rc = rtas_call(rtas_token("get-sensor-state"), 2, 2, &dr_status,
> +		       DR_ENTITY_SENSE, drc_index);
> +	if (rc || dr_status != DR_ENTITY_UNUSABLE)
> +		return -1;
> +
> +	rc = rtas_set_indicator(ALLOCATION_STATE, drc_index, ALLOC_USABLE);
> +	if (rc)
> +		return rc;
> +
> +	rc = rtas_set_indicator(ISOLATION_STATE, drc_index, UNISOLATE);
> +	if (rc) {
> +		rtas_set_indicator(ALLOCATION_STATE, drc_index, ALLOC_UNUSABLE);
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +int release_drc(u32 drc_index)
> +{
> +	int dr_status, rc;
> +
> +	rc = rtas_call(rtas_token("get-sensor-state"), 2, 2, &dr_status,
> +		       DR_ENTITY_SENSE, drc_index);
> +	if (rc || dr_status != DR_ENTITY_PRESENT)
> +		return -1;
> +
> +	rc = rtas_set_indicator(ISOLATION_STATE, drc_index, ISOLATE);
> +	if (rc)
> +		return rc;
> +
> +	rc = rtas_set_indicator(ALLOCATION_STATE, drc_index, ALLOC_UNUSABLE);
> +	if (rc) {
> +		rtas_set_indicator(ISOLATION_STATE, drc_index, UNISOLATE);
> +		return rc;
> +	}
> +
> +	return 0;
> +}

Both above should have a dlpar_* prefix

> +static int pseries_dlpar_init(void)
> +{
> +	if (!machine_is(pseries))
> +		return 0;
> +
> +	return 0;
> +}
> +device_initcall(pseries_dlpar_init);

What the point ? :-)

Cheers
Ben.

