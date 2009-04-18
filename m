Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbZDRTHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbZDRTHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 15:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZDRTHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 15:07:32 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1803 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752357AbZDRTHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 15:07:32 -0400
X-Greylist: delayed 1848 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Apr 2009 15:07:27 EDT
Message-ID: <49EA1DAC.1000602@myri.com>
Date: Sat, 18 Apr 2009 20:36:28 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux Network Development list <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] myri10ge: allow per-board firmware overriding
References: <49E7239B.4000309@myri.com> <20090417095038.49b745bf@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20090417095038.49b745bf@dhcp-lab-109.englab.brq.redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw Gruszka wrote:
> On Thu, 16 Apr 2009 14:24:59 +0200
> Brice Goglin <brice@myri.com> wrote:
>
>   
>> --- linux-tmp.old/drivers/net/myri10ge/myri10ge.c	2009-04-08 06:56:50.000000000 +0200
>> +++ linux-tmp/drivers/net/myri10ge/myri10ge.c	2009-04-09 14:00:16.000000000 +0200
>> @@ -255,6 +255,7 @@
>>  	u32 read_write_dma;
>>  	u32 link_changes;
>>  	u32 msg_enable;
>> +	unsigned int board_number;
>>  };
>>  
>>  static char *myri10ge_fw_unaligned = "myri10ge_ethp_z8e.dat";
>> @@ -266,6 +267,13 @@
>>  module_param(myri10ge_fw_name, charp, S_IRUGO | S_IWUSR);
>>  MODULE_PARM_DESC(myri10ge_fw_name, "Firmware image name");
>>  
>> +#define MYRI10GE_MAX_BOARDS 8
>> +static char *myri10ge_fw_names[MYRI10GE_MAX_BOARDS] =
>> +    {[0...(MYRI10GE_MAX_BOARDS - 1)] = NULL };
>> +module_param_array_named(myri10ge_fw_names, myri10ge_fw_names, charp, NULL,
>> +			 0444);
>> +MODULE_PARM_DESC(myri10ge_fw_name, "Firmware image names per board");
>> +
>>  static int myri10ge_ecrc_enable = 1;
>>  module_param(myri10ge_ecrc_enable, int, S_IRUGO);
>>  MODULE_PARM_DESC(myri10ge_ecrc_enable, "Enable Extended CRC on PCI-E");
>> @@ -3258,6 +3266,8 @@
>>  
>>  static void myri10ge_select_firmware(struct myri10ge_priv *mgp)
>>  {
>> +	int overridden = 0;
>> +
>>  	if (myri10ge_force_firmware == 0) {
>>  		int link_width, exp_cap;
>>  		u16 lnk;
>> @@ -3291,10 +3301,18 @@
>>  		}
>>  	}
>>  	if (myri10ge_fw_name != NULL) {
>> -		dev_info(&mgp->pdev->dev, "overriding firmware to %s\n",
>> -			 myri10ge_fw_name);
>> +		overridden = 1;
>>  		mgp->fw_name = myri10ge_fw_name;
>>  	}
>> +	if (mgp->board_number < MYRI10GE_MAX_BOARDS &&
>> +	    myri10ge_fw_names[mgp->board_number] != NULL &&
>> +	    strlen(myri10ge_fw_names[mgp->board_number])) {
>> +		mgp->fw_name = myri10ge_fw_names[mgp->board_number];
>> +		overridden = 1;
>> +	}
>> +	if (overridden)
>> +		dev_info(&mgp->pdev->dev, "overriding firmware to %s\n",
>> +			 mgp->fw_name);
>>  }
>>  
>>  #ifdef CONFIG_PM
>> @@ -3759,6 +3777,7 @@
>>  	int status = -ENXIO;
>>  	int dac_enabled;
>>  	unsigned hdr_offset, ss_offset;
>> +	static int board_number;
>>  
>>  	netdev = alloc_etherdev_mq(sizeof(*mgp), MYRI10GE_MAX_SLICES);
>>  	if (netdev == NULL) {
>> @@ -3775,6 +3794,7 @@
>>  	mgp->pause = myri10ge_flow_control;
>>  	mgp->intr_coal_delay = myri10ge_intr_coal_delay;
>>  	mgp->msg_enable = netif_msg_init(myri10ge_debug, MYRI10GE_MSG_DEFAULT);
>> +	mgp->board_number = board_number;
>>  	init_waitqueue_head(&mgp->down_wq);
>>  
>>  	if (pci_enable_device(pdev)) {
>> @@ -3925,6 +3945,7 @@
>>  			 netdev->irq, mgp->tx_boundary, mgp->fw_name,
>>  			 (mgp->wc_enabled ? "Enabled" : "Disabled"));
>>  
>> +	board_number++;
>>  	return 0;
>>  
>>  abort_with_state:
>>     
>
> Code assumes boards are always initialized in the same order. I suppose
> this is always true and is nothing wrong here. However perhaps linux could
> provide some form of modules/boot parameters that are used with
> an identification number like MAC address. Example:
>
> module my_parms="id1:param1;id2:param2;" 
>
> char *get_module_param_id(const char *param, const char *id)
>
> This would help in situation like this - admin will not have to thinking
> about boards initialization ordering. Besides some other drivers (like MTD
> cmd partitions) use own parsing for similar things, I think would be
> nice to unify things. What You think?
>   

We actually thought about supporting "eth2:fwname1,eth0:fwname2". But it
might be hard to implement in this case due to udev possible renaming
interfaces and this firmware names being needed *before* the renaming.
So yes, an automatic way to handle such parameter strings might be good,
but maybe not in this exact case.

Brice

