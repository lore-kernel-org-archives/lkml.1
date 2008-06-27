Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbYF0LI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbYF0LI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbYF0LIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:08:20 -0400
Received: from ns2.suse.de ([195.135.220.15]:60300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbYF0LIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:08:19 -0400
Date: Fri, 27 Jun 2008 13:08:57 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Greg KH <gregkh@suse.de>
Cc: x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
Message-ID: <20080627130857.6d543a75@halley.suse.de>
In-Reply-To: <20080626222458.GA18981@suse.de>
References: <1214511542-28458-1-git-send-email-bwalle@suse.de>
	<1214511542-28458-2-git-send-email-bwalle@suse.de>
	<20080626222458.GA18981@suse.de>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Greg KH [2008-06-26 15:24]:
>
> On Thu, Jun 26, 2008 at 10:19:01PM +0200, Bernhard Walle wrote:
> > This patch adds /sys/firmware/memmap interface that represents the BIOS
> > (or Firmware) provided memory map. The tree looks like:
> > 
> >     /sys/firmware/memmap/0/start   (hex number)
> >                            end     (hex number)
> >                            type    (string)
> >     ...                 /1/start
> >                            end
> >                            type
> 
> Please provide new entries in Documentation/ABI/ for these new sysfs
> files with all of this information.

Yes, I planned that but wanted to get feedback first. It's in the next
resend.

> > +/*
> > + * Firmware memory map entries
> > + */
> > +LIST_HEAD(map_entries);
> 
> Should this be static?

Yes, thanks.

> > +int firmware_map_add(resource_size_t start, resource_size_t end,
> > +		     const char *type)
> > +{
> > +	struct firmware_map_entry *entry;
> > +
> > +	entry = kmalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
> > +	WARN_ON(!entry);
> > +	if (!entry)
> > +		return -ENOMEM;
> > +
> > +	return firmware_map_add_entry(start, end, type, entry);
> 
> Where is the kobject initialized properly?
> 
> Ah, later on, that's scary...

Ok, I moved initialisation to firmware_map_add_entry() and add it later
with kobject_add().

> > +static struct kobj_type memmap_ktype = {
> > +	.sysfs_ops	= &memmap_attr_ops,
> > +	.default_attrs	= def_attrs,
> > +};
> 
> Do you really need your own kobj_type here?  What you want is just a
> directory, and some attributes assigned to the kobject, can't you use
> the default kobject attributes for them?
> 
> I'm not saying this is incorrect, it looks implemented properly, just
> curious.

Well, since there are more than one directory with the same attributes,
isn't using kobj_type easier here?

> > +static int __init memmap_init(void)
> > +{
> > +	int i = 0;
> > +	struct firmware_map_entry *entry;
> > +	struct kset *memmap_kset;
> > +
> > +	memmap_kset = kset_create_and_add("memmap", NULL, firmware_kobj);
> > +	WARN_ON(!memmap_kset);
> > +	if (!memmap_kset)
> > +		return -ENOMEM;
> > +
> > +	list_for_each_entry(entry, &map_entries, list) {
> 
> So the list is supposed to be set up before this function is called?  Is
> that because of early boot issues?
> 
> You should document this somehow.

Yes, added a comment to firmware_map_add_early(), firmware_map_add()
and before memmap_init().

> > +/*
> > + * Firmware map entry. Because firmware memory maps are flat and not
> > + * hierarchical, it's ok to organise them in a linked list. No parent
> > + * information is necessary as for the resource tree.
> > + */
> > +struct firmware_map_entry {
> > +	resource_size_t		start;	/* start of the memory range */
> > +	resource_size_t		end;	/* end of the memory range (incl.) */
> > +	const char		*type;	/* type of the memory range */
> > +	struct list_head	list;	/* entry for the linked list */
> > +	struct kobject		kobj;   /* kobject for each entry */
> > +};
> 
> Does this really need to be in the .h file?

No, that was because I modified the API afterwards. Thanks for spotting
that.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
