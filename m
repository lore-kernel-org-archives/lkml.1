Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbZGSFHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbZGSFHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 01:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZGSFHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 01:07:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:56567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbZGSFHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 01:07:36 -0400
Subject: Re: [HWMON] x86: hwmon/k8temp.c Add support for AMD 11H
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rudolf Marek <r.marek@assembler.cz>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       Chuck Ebbert <cebbert@fedoraproject.org>,
       fedora-kernel-owner <kernel-owner@fedoraproject.org>,
       Jean Delvare <khali@linux-fr.org>
In-Reply-To: <1245938943.5308.56.camel@hpdv5.satnam>
References: <1242979484.8796.7.camel@localhost.localdomain>
	 <4A165F67.3020005@assembler.cz>
	 <1242981748.10642.3.camel@localhost.localdomain>
	 <1242984648.16532.3.camel@localhost.localdomain>
	 <4A182B61.5010503@assembler.cz>
	 <1243339833.12303.2.camel@localhost.localdomain>
	 <4A1C08C6.7060103@assembler.cz>
	 <1243352672.31783.10.camel@localhost.localdomain>
	 <1245484600.3102.9.camel@localhost.localdomain>
	 <1245938943.5308.56.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Sun, 19 Jul 2009 10:33:00 +0530
Message-Id: <1247979780.3037.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

Now I do not use -tip tree, if you want you can remove this patch from
-tip (commit 318e6a08d340d85)

Thanks for your help and support.
--
JSR

On Thu, 2009-06-25 at 19:39 +0530, Jaswinder Singh Rajput wrote:
> Ingo,
> 
> I need to apply and then revert this patch each and every time I fetch
> -tip tree. And I need to do this many times like 20-30 times in a day.
> 
> I need this patch to monitor the temperature for AMD 11H box as it is
> very hot here temp is around 47 C and my CPU temp goes high upto 87 C.
> My one AMD box is already broken due to high temperature.
> 
> By using this patch I breaks building of the kernel as temperature
> reaches 80 C.
> 
> I hope you understand my problem.
> 
> If possible, can you please apply this patch in tip:out-of-tree 
> (not-for-upstream)
> 
> Thanks,
> --
> JSR
> 
> On Sat, 2009-06-20 at 13:26 +0530, Jaswinder Singh Rajput wrote:
> > This patch will also work for AMD 10H. But we are skipping it as :
> > 
> > AMD 10H cpus reports Inaccurate Temperature Measurement:
> > http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/41322.pdf
> > Errata #319
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  drivers/hwmon/k8temp.c |   31 +++++++++++++++++++++++++++++--
> >  1 files changed, 29 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
> > index 1fe9951..4459dbf 100644
> > --- a/drivers/hwmon/k8temp.c
> > +++ b/drivers/hwmon/k8temp.c
> > @@ -1,5 +1,6 @@
> >  /*
> >   * k8temp.c - Linux kernel module for hardware monitoring
> > + * 	      for AMD K8 and derivatives
> >   *
> >   * Copyright (C) 2006 Rudolf Marek <r.marek@assembler.cz>
> >   *
> > @@ -33,7 +34,7 @@
> >  #include <linux/mutex.h>
> >  #include <asm/processor.h>
> >  
> > -#define TEMP_FROM_REG(val)	(((((val) >> 16) & 0xff) - 49) * 1000)
> > +#define REG_TCTL	0xa4
> >  #define REG_TEMP	0xe4
> >  #define SEL_PLACE	0x40
> >  #define SEL_CORE	0x04
> > @@ -52,6 +53,14 @@ struct k8temp_data {
> >  	u32 temp_offset;
> >  };
> >  
> > +static unsigned long temp_from_reg(unsigned long val)
> > +{
> > +	if (boot_cpu_data.x86 > 0xf)
> > +		return ((val) >> 21) * 125;
> > +	else
> > +		return ((((val) >> 16) & 0xff) - 49) * 1000;
> > +}
> > +
> >  static struct k8temp_data *k8temp_update_device(struct device *dev)
> >  {
> >  	struct k8temp_data *data = dev_get_drvdata(dev);
> > @@ -62,6 +71,11 @@ static struct k8temp_data *k8temp_update_device(struct device *dev)
> >  
> >  	if (!data->valid
> >  	    || time_after(jiffies, data->last_updated + HZ)) {
> > +		if (boot_cpu_data.x86 > 0xf) {
> > +			pci_read_config_dword(pdev, REG_TCTL,
> > +					      &data->temp[0][0]);
> > +			goto update_done;
> > +		}
> >  		pci_read_config_byte(pdev, REG_TEMP, &tmp);
> >  		tmp &= ~(SEL_PLACE | SEL_CORE);		/* Select sensor 0, core0 */
> >  		pci_write_config_byte(pdev, REG_TEMP, tmp);
> > @@ -89,6 +103,7 @@ static struct k8temp_data *k8temp_update_device(struct device *dev)
> >  			}
> >  		}
> >  
> > +update_done:
> >  		data->last_updated = jiffies;
> >  		data->valid = 1;
> >  	}
> > @@ -123,7 +138,7 @@ static ssize_t show_temp(struct device *dev,
> >  	if (data->swap_core_select)
> >  		core = core ? 0 : 1;
> >  
> > -	temp = TEMP_FROM_REG(data->temp[core][place]) + data->temp_offset;
> > +	temp = temp_from_reg(data->temp[core][place]) + data->temp_offset;
> >  
> >  	return sprintf(buf, "%d\n", temp);
> >  }
> > @@ -138,6 +153,14 @@ static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
> >  
> >  static struct pci_device_id k8temp_ids[] = {
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
> > +	/*
> > +	 * AMD 10H cpus reports Inaccurate Temperature Measurement :
> > +	 * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/41322.pdf
> > +	 *     Errata #319
> > +	 * So skipping 10H
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
> > +	 */
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
> >  	{ 0 },
> >  };
> >  
> > @@ -157,6 +180,9 @@ static int __devinit k8temp_probe(struct pci_dev *pdev,
> >  		goto exit;
> >  	}
> >  
> > +	if (boot_cpu_data.x86 > 0xf)
> > +		goto probe_done;
> > +
> >  	model = boot_cpu_data.x86_model;
> >  	stepping = boot_cpu_data.x86_mask;
> >  
> > @@ -226,6 +252,7 @@ static int __devinit k8temp_probe(struct pci_dev *pdev,
> >  			data->sensorsp &= ~SEL_CORE;
> >  	}
> >  
> > +probe_done:
> >  	data->name = "k8temp";
> >  	mutex_init(&data->update_lock);
> >  	dev_set_drvdata(&pdev->dev, data);

