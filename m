Return-Path: <linux-kernel-owner+w=401wt.eu-S1764187AbZEHVDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764187AbZEHVDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573AbZEHVDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:03:37 -0400
Received: from web50107.mail.re2.yahoo.com ([206.190.38.35]:21158 "HELO
	web50107.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757194AbZEHVDg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:03:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ss6uY/zfgoICA0Pu8iP8zsCYlubtu3NrLfRnNtB6xzEu0HG41VyYrggM4Yb5/vRjHyHJ/NaMB6Cz8cumS4nIOpsl2ZC+yh2aGVLI5sPgQlL3vsytdIoxzbFJKY8054XE57VJBPxdx61MKC/sXL/WyBGfDCA2gYPi2pseAiz97Kw=;
Message-ID: <112179.84196.qm@web50107.mail.re2.yahoo.com>
X-YMail-OSG: _WzgzsQVM1kFapehrJOhg1W1uu287Y0VIMzVd8MhQg_QfFjO7d.4LzAZ
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Fri, 8 May 2009 14:03:35 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 21/21] amd64_edac: add module registration routines
To: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, greg@kroah.com, tglx@linutronix.de,
       hpa@zytor.com, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Thu, 5/7/09, Ingo Molnar <mingo@elte.hu> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [PATCH 21/21] amd64_edac: add module registration routines
> To: "Borislav Petkov" <borislav.petkov@amd.com>
> Cc: akpm@linux-foundation.org, greg@kroah.com, norsk5@yahoo.com, tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com, aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org, "Doug Thompson" <dougthompson@xmission.com>
> Date: Thursday, May 7, 2009, 3:58 PM
> 
> * Borislav Petkov <borislav.petkov@amd.com>
> wrote:
> 
> > +      Recent Opterons (Family 10h
> and later) provide for Memory Error
> > +      Injection into the ECC
> detection circuits. The amd64_edac module
> > +      allows the operator/user to
> inject Uncorrectable and Correctable
> > +      errors into DRAM.
> > +
> > +      When enabled, in each of
> the respective memory controller directories
> > +     
> (/sys/devices/system/edac/mc/mcX), there are 3 input files:
> > +
> > +      - z_inject_section (0..3,
> 16-byte section of 64-byte cacheline),
> > +      - z_inject_word (0..8,
> 16-bit word of 16-byte section),
> > +      - z_inject_bit_map (hex
> bitmap vector: mask bits of 16 bit word to
> > +        error-out)
> > +
> > +      In addition, there are two
> control files, z_inject_read and
> > +      z_inject_write, which
> trigger the Read and Write errors respectively.
> 
> I think the file names should follow existing EDAC driver
> practices, 
> and be named according to the existing inject_data_*
> pattern?
> 
> There's nothing more annoying to users (and tools) than
> inconsistent 
> driver namespaces.
> 

originally the injection was enabled only for development debug, but
was changed to a .config switch.  The 'z-*' use was to sort the directory list with those debug files to the bottom of the list.

So now, yes they should have the 'z-*' prefix removed.

> > +    /* Exam the capabilities of the
> northbridge in order to reflect them
> > +     * in the presentation
> via sysfs attributes, etc
> > +     */
> 
> please use the customary comment style:
> 
>   /*
>    * Comment .....
>    * ...... goes here:
>    */
> 
> also described in Documentation/CodingStyle.
> 
> This is a continuing observation for a number of other
> cases where 
> you introduce half-winged comments.

yeah, we missed some of those

> > +
> > +    /* IMPORTANT: Set the polling
> 'check' function in this module */
> > +    mci->edac_check = amd64_check;
> > +
> > +    /* memory scrubber interface */
> > +    mci->set_sdram_scrub_rate =
> amd64_set_scrub_rate;
> > +    mci->get_sdram_scrub_rate =
> amd64_get_scrub_rate;
> > +}
> > +
> > +/*
> > + * amd64_probe_one_instance
> > + *
> > + *    probe function to determine if there
> is a DRAM Controller device is
> > + *    present and to construct data tables
> for it.
> > + *
> > + *    Due to a hardware feature on Family
> 10H cpus, the Enable Extended
> > + *    Configuration Space feature MUST be
> enabled on ALL Processors prior to
> > + *    actually reading from the ECS
> registers. Since the loading of the module
> > + *    can occur on any 'core', and cores
> don't 'see' all the other processors
> > + *    ECS data when the others are NOT
> enabled. Our solution is to first
> > + *    enable ECS access in this routine on
> all processors, gather some data in
> > + *    a amd64_pvt structure and later come
> back in a 'finishup_setup' function
> > + *    to perform that final
> initialization.
> > + *
> > + *    See also amd64_init_2nd_stage().
> > + */
> 
> Nice comment!
> 

IBM guys created that one with their patch after they found the 'issue'


> > +static int amd64_probe_one_instance(struct pci_dev
> *dram_f2_ctl,
> > +       
>             int
> mc_type_index)
> > +{
> > +    struct amd64_pvt *pvt;
> > +    int err;
> > +    int rc;
> > +
> > +    pvt = kzalloc(sizeof(struct
> amd64_pvt), GFP_KERNEL);
> > +    if (pvt == NULL) {
> > +        rc = -ENOMEM;
> > +        goto exit_now;
> > +    }
> 
> The customary pattern is:
> 
>     ret = -ENOMEM;
>     pvt = kzalloc(sizeof(struct amd64_pvt),
> GFP_KERNEL);
>     if (!pvt)
>         goto err;
> 
> Note the four differences:
> 
>  - use 'ret' instead of 'rc' for integer returns
>  - pre-initialize 'ret', not in the exception branch
>  - !pvt instead of 'pvt == NULL'
>  - use 'err*' naming for error labels
> 

ok, thanks

> 
> > +    pvt->mc_node_id =
> get_mc_node_id_from_pdev(dram_f2_ctl);
> > +
> > +    debugf0("=========== %s(Instance=
> %d) ===========\n",
> > +        __func__,
> pvt->mc_node_id);
> 
> please use something like trace_printk() instead. That will
> allow 
> high-performance tracing of this code, should the need
> arise. Also 
> 'debugf0' says nothing - what does it mean?

debugfX() is a set of macros in the EDAC CORE (already in the kernel)  that has 4 levels of verbosity, X=(0..3). Increase the number increases the output. This output is only enabled via the DEBUG switch. In normal operation, DEBUG should be off. It accesses a debug variable in sysfs which allows the developer to increase error reporting granularity. 

> > +
> > +    rc =
> amd64_check_ecc_enabled(pvt);
> > +    if (rc)
> > +        goto
> exit_release_devices;
> 
> Bug: in the error case there's now a memory leak of 'pvt'.
> 

ow, yeah. Thanks for that catch

> > +
> > +    /*
> > +     * Save the pointer to
> the private data for use in 2nd initialization
> > +     * stage
> > +     */
> > +    pvt_lookup[pvt->mc_node_id] =
> pvt;
> > +
> > +    debugf0("%s(): init 1st stage done
> pvt-%d\n", __func__,
> > +       
> pvt->mc_node_id);
> > +    return 0;
> > +
> > +
> > +exit_release_devices:
> > +    pci_dev_put(pvt->addr_f1_ctl);
> > +    pci_dev_put(pvt->misc_f3_ctl);
> 
> this teardown is correct but a bit unclean: it open-codes
> the 
> reverse direction of:
> 
>     err =
> amd64_reserve_mc_sibling_devices(pvt, mc_type_index);
> 
> It would be better to add a
> amd64_free_mc_sibling_devices(pvt) 
> method.
> 

ah, good point

> > +
> > +    /*
> > +     * transfer the info
> from the interium pvt area to the private area of
> > +     * the MC instance
> structure
> > +     */
> > +    pvt = mci->pvt_info;
> > +    *pvt = *pvt_temp;
> 
> hm, such copying can be dangerous. If pvt_temp ever grows
> something 
> like a list_head, then the copy can corrupt the list. Could
> this be 
> avoided?

Yeah, it was a misgiving to me as well. It came from the 1st/2nd stage patch set. Needed to 'save' various harvested information during the 1st stage (after all the CPU's had been setup).

The constructor of the MCI object (in EDAC CORE) is a single memory allocated area to hold all the info, but it was dependent on the how many CSROWS and CHANNELS there were to save memory. So the actual 'private' area is within the bounds of the MCI allocation.  The temporary allocation was a temp storage area until the MCI structure was finally allocated, which occurs in the 2nd stage pass.

The 'private' area is defined differently in each of the various EDAC modules. The amd64 module definitely has an involved twist on initialization.


> > +
> > +   
> kfree(pvt_lookup[pvt->mc_node_id]);
> > +    pvt_lookup[node_id] = NULL;
> > +
> > +    return rc;
> > +}
> > +
> > +
> > +/*
> > + * amd64_init_one_instance
> > + *
> > + *    initialize just one device
> > + *
> > + *    returns:
> > + *   
>      count (>= 0), or
> > + *        negative on
> error
> > + */
> > +static int __devinit amd64_init_one_instance(struct
> pci_dev *pdev,
> > +       
>          const
> struct pci_device_id *mc_type)
> > +{
> > +    int rc;
> > +
> > +    debugf0("%s(MC
> node=%d,mc_type='%s')\n",
> > +        __func__,
> > +       
> get_mc_node_id_from_pdev(pdev),
> > +       
> get_amd_family_name(mc_type->driver_data));
> > +
> > +    /* wake up and enable device */
> > +    rc = pci_enable_device(pdev);
> > +    if (rc < 0)
> > +        rc = -EIO;
> > +    else
> > +        rc =
> amd64_probe_one_instance(pdev, mc_type->driver_data);
> > +
> > +    if (rc < 0)
> > +        debugf0("%s()
> rc=%d\n", __func__, rc);
> 
> there's way too many debugf*() calls in the whole code,
> often 
> obscuring the real structure. I think we'll be far better
> off with 
> having just a few key ones.

Probably, but the reverse mapping of the amd64 uses many data fields. I added so many debug output to harvest that data so as to debug the code.  I added some lines to be able to partition the output to isolate various data output in order to "see" it faster in the log.

But there ARE some lines that are remnants that could be removed.

> > +};
> > +
> > +
> > +/*
> > + * amd64_setup_pci_device
> > + *
> > + *    setup the PCI Device Driver for
> monitoring PCI errors
> > + */
> > +static void amd64_setup_pci_device(void)
> > +{
> > +    struct mem_ctl_info *mci;
> > +    struct amd64_pvt *pvt;
> > +
> > +    if (!amd64_ctl_pci) {
> 
> this branch goes on:
> 
> > +
> > +        mci =
> mci_lookup[0];
> > +        if (mci) {
> > +       
>     debugf1("%s(): Registering ONE PCI
> control\n",
> > +       
>         __func__);
> 
> and on:
> 
> > +
> > +       
>     pvt = mci->pvt_info;
> > +       
>     amd64_ctl_pci =
> edac_pci_create_generic_ctl(
> > +       
>            
>     &pvt->dram_f2_ctl->dev,
> > +       
>            
>     EDAC_MOD_STR);
> > +       
>     if (!amd64_ctl_pci) {
> 
> and on:
> 
> > +       
>         printk(KERN_WARNING
> > +       
>            
> "%s(): Unable to create PCI control\n",
> > +       
>            
> __func__);
> 
> And here you have too many tabs (five of them), that break
> up that 
> printk in an ugly way.
> 
> The better solution is to realize that the branch could be
> inverted 
> and a full level of indentation won by doing:
> 
>     if (amd64_ctl_pci)
>         return;
> 
> And winning another level of indentation later on by
> doing:
> 
>     if (mci) {
>         debugf1("%s(): ONE
> PCI control already registered\n",
>            
>     __func__);
>         return;
>     }
> 
> Btw., please change all instances of:
> 
>    printk(KERN_WARNING,   
>    => pr_warning(
>    printk(KERN_INFO,     
>     => pr_info(
> 
> etc.
> 
> > +       
>         printk(KERN_WARNING
> > +       
>            
> "%s(): PCI error report via EDAC "
> > +       
>            
> "not setup\n",
> > +       
>            
> __func__);
> > +       
>     }
> > +        } else {
> > +       
>     debugf1("%s(): ONE PCI control already
> registered\n",
> > +       
>         __func__);
> > +        }
> > +    }
> > +}
> > +
> > +static int __init amd64_edac_init(void)
> > +{
> > +    int err;
> > +    int node;
> > +
> > +    edac_printk(KERN_INFO,
> EDAC_MOD_STR, EDAC_AMD64_VERSION "\n");
> > +
> > +    opstate_init();
> > +
> > +    debugf0("%s()
> ******************  ENTRY 
> **********************\n",
> > +        __func__);
> 
> 
> if you want a debug facility, please shorten it to
> something like:
> 
>     dbg(" **** ENTRY ****\n")
> 
> and make the printing of __func__ implicit in the dbg()
> method.  
> This will shorten these things quite a bit. But please get
> rid of 
> most of them - there's no excuse for having such things in
> the 
> kernel beyond the first 1-2 days of the development of this
> 
> function.
> 

Good idea to fold the __func__ into the macro.

For each CPU socket this gets called and I used these to 
isolate each instance in a 2, 4 or 8 socket based system
True, used for ease of debugging


> > +    /* Attempt to register drivers for
> instances
> > +     * DUE to the failure of
> some 'cores' to access Extended Config Space
> > +     * prior to all memory
> controllers having their ECS register enabled,
> > +     * the initialization
> has been created into 2 stages. Here we
> > +     * call for the 1st
> stage. After all have been enabled, then we
> > +     * do the 2nd stage to
> finishup setup.
> > +     */
> > +    err =
> pci_register_driver(&amd64_pci_driver);
> > +
> > +    /* At this point, the array
> 'pvt_lookup[]' contains pointers to
> > +     * allocated struct
> amd64_pvt control structures. These will be used
> > +     * in the 2nd stage init
> function to finish initialization of
> > +     * the MC instances.
> > +     */
> 
> after using good comment style for a while, bad comment
> style shows 
> up again.

yeah, again, didn't get all of them yet

> 
> > +
> > +    /* if no error occurred on first
> pass init, then do 2nd pass init */
> > +    if (!err) {
> 
> Again, by doing:
> 
>     if (err)
>         goto err;
> 
> You can save an identation level below, and avoid line-wrap
> 
> artifacts. 
> 

ok

> > +       
> for_each_online_node(node) {
> > +       
>     if (!pvt_lookup[node])
> > +       
>         continue;
> > +
> > +       
>     /* If any failure then need to clean up
> */
> > +       
>     err =
> amd64_init_2nd_stage(pvt_lookup[node]);
> > +       
>     if (err) {
> > +       
>         debugf0("%s()
> 'finish_setup' stage failed\n",
> > +       
>            
> __func__);
> > +
> > +       
>         /* undo prior
> instances' registrations
> > +       
>          * and leave
> as failed
> > +       
>          */
> > +       
>        
> pci_unregister_driver(&amd64_pci_driver);
> > +       
>         goto error_exit;
> > +       
>     }
> > +        }
> > +       
> amd64_setup_pci_device();
> > +    }
> > +
> > +error_exit:
> > +    return err;
> > +}
> > +
> > +static void __exit amd64_edac_exit(void)
> > +{
> > +    if (amd64_ctl_pci)
> > +       
> edac_pci_release_generic_ctl(amd64_ctl_pci);
> > +
> > +   
> pci_unregister_driver(&amd64_pci_driver);
> > +}
> > +
> > +module_init(amd64_edac_init);
> > +module_exit(amd64_edac_exit);
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("SoftwareBitMaker: Doug Thompson, "
> > +        "Dave Peterson,
> Thayne Harbaugh");
> > +MODULE_DESCRIPTION("MC support for AMD64 memory
> controllers - "
> > +       
> EDAC_AMD64_VERSION);
> > +
> > +module_param(edac_op_state, int, 0444);
> > +MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting
> state: 0=Poll,1=NMI");
> > diff --git a/drivers/edac/amd64_edac.h
> b/drivers/edac/amd64_edac.h
> > index d435ace..a3603f7 100644
> > --- a/drivers/edac/amd64_edac.h
> > +++ b/drivers/edac/amd64_edac.h
> > @@ -891,6 +891,11 @@ extern const char *ii_msgs[4];
> >  extern const char *ext_msgs[32];
> >  extern const char *htlink_msgs[8];
> >  
> > +#define NUM_DBG_ATTRS  9
> > +#define NUM_INJ_ATTRS  5
> > +extern struct mcidev_sysfs_attribute
> amd64_dbg_attrs[NUM_DBG_ATTRS],
> > +       
>          
>    amd64_inj_attrs[NUM_INJ_ATTRS];
> > +
> >  /*
> >   * Each of the PCI Device IDs types
> have their own set of hardware
> >   * accessor function and per device
> encoding/decoding logic.
> > diff --git a/drivers/edac/amd64_edac_dbg.c
> b/drivers/edac/amd64_edac_dbg.c
> > index 3741af9..f538129 100644
> > --- a/drivers/edac/amd64_edac_dbg.c
> > +++ b/drivers/edac/amd64_edac_dbg.c
> > @@ -211,6 +211,9 @@ static ssize_t
> amd64_hole_show(struct mem_ctl_info *mci, char *data)
> >         
>            
>      hole_size);
> >  }
> >  
> > +/*
> > + * update NUM_DBG_ATTRS in case you add new members
> > + */
> >  struct mcidev_sysfs_attribute amd64_dbg_attrs[]
> = {
> >  
> >      {
> > diff --git a/drivers/edac/amd64_edac_inj.c
> b/drivers/edac/amd64_edac_inj.c
> > index 7f978cb..8706954 100644
> > --- a/drivers/edac/amd64_edac_inj.c
> > +++ b/drivers/edac/amd64_edac_inj.c
> > @@ -155,6 +155,9 @@ static ssize_t
> amd64_inject_write_store(struct mem_ctl_info *mci,
> >      return 0;
> >  }
> >  
> > +/*
> > + * update NUM_INJ_ATTRS in case you add new members
> > + */
> >  struct mcidev_sysfs_attribute amd64_inj_attrs[]
> = {
> >  
> >      {
> 
> Looks like these fixlets dont really belong in this patch
> and should 
> either be backmerged or put into a separate patch?
> 
>     Ingo
> 

thanks for the diligence Ingo


