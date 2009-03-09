Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZCISHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZCISHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZCISHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:07:23 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:57389 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZCISHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:07:21 -0400
Message-ID: <49B55B3E.3090502@oracle.com>
Date: Mon, 09 Mar 2009 11:09:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yu Zhao <yu.zhao@intel.com>
CC: Matthew Wilcox <matthew@wil.cx>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 3/7] PCI: reserve bus range for SR-IOV device
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-4-git-send-email-yu.zhao@intel.com> <20090306202024.GF25995@parisc-linux.org> <20090309081337.GB4638@yzhao-otc.sh.intel.com>
In-Reply-To: <20090309081337.GB4638@yzhao-otc.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49B55AD3.0130:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yu Zhao wrote:
> On Sat, Mar 07, 2009 at 04:20:24AM +0800, Matthew Wilcox wrote:
>> On Fri, Feb 20, 2009 at 02:54:44PM +0800, Yu Zhao wrote:
>>> +static inline void virtfn_bdf(struct pci_dev *dev, int id, u8 *busnr, u8 *devfn)
>>> +{
>>> +	u16 bdf;
>>> +
>>> +	bdf = (dev->bus->number << 8) + dev->devfn +
>>> +	      dev->sriov->offset + dev->sriov->stride * id;
>>> +	*busnr = bdf >> 8;
>>> +	*devfn = bdf & 0xff;
>>> +}
>> I find the interface here a bit clunky -- a function returning void
>> while having two OUT parameters.  How about this variation on the theme
>> (viewers are encouraged to come up with their own preferred
>> implementations and interfaces):
>>
>> static inline __pure u16 virtfn_bdf(struct pci_dev *dev, int id)
>> {
>> 	return (dev->bus->number << 8) + dev->devfn + dev->sriov->offset +
>> 		dev->sriov->stride * id;
>> }
>>
>> #define VIRT_BUS(dev, id)	(virtfn_bdf(dev, id) >> 8)
>> #define VIRT_DEVFN(dev, id)	(virtfn_bdf(dev, id) & 0xff)
>>
>> We rely on GCC to do CSE and not actually invoke virtfn_bdf more than
>> once.
> 
> Yes, that's a good idea. Will replace that function with macros.

That's the opposite of most changes lately.  I.e., functions (with
typechecking) are preferred.

-- 
~Randy
