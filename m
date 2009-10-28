Return-Path: <linux-kernel-owner+w=401wt.eu-S1751573AbZJ1Svj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbZJ1Svj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZJ1Svf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:51:35 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:60445 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZJ1Svc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:51:32 -0400
Message-ID: <4AE892B5.1030500@linux.vnet.ibm.com>
Date: Wed, 28 Oct 2009 16:51:33 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090614)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: David Safford <safford@watson.ibm.com>, Eric Paris <eparis@parisplace.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Jean-Christophe Dubois <jcd@tribudubois.net>,
       Mimi Zohar <zohar@us.ibm.com>, Stable Kernel <stable@kernel.org>
Subject: Re: [PATCH] ima: remove ACPI dependency
References: <1256563579-11014-1-git-send-email-zohar@linux.vnet.ibm.com> <1256563579-11014-2-git-send-email-zohar@linux.vnet.ibm.com> <7e0fb38c0910270658v153480fdt5ced717feca76c17@mail.gmail.com> <1256659146.3028.29.camel@localhost.localdomain> <1256661407.2804.15.camel@dhcp231-106.rdu.redhat.com> <1256676127.3028.86.camel@localhost.localdomain> <1256677010.10981.3.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1256677010.10981.3.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> On Tue, 2009-10-27 at 16:42 -0400, David Safford wrote:
>   
>> On Tue, 2009-10-27 at 12:36 -0400, Eric Paris wrote:
>>     
>>> On Tue, 2009-10-27 at 11:59 -0400, David Safford wrote:
>>>       
>>>> Basically, if running on a system with a TPM, IMA wants the TPM
>>>> boot measurement log, which the TPM driver can only get through
>>>> ACPI. If the platform does not have a TPM, then IMA does not 
>>>> need ACPI.
>>>>         
>>> I'm afraid I'm not seeing the connection.  Where does IMA gets the boot
>>> measurement log?  I see that the TPM exports that log in securityfs as 2
>>> files (ascii and binary) in tpm_bios.c but I don't see how IMA ever
>>> makes use of that log either internally to the kernel or through the
>>> securityfs files.
>>>
>>>       
>> sorry - bad explanation. IMA reads PCR 0-7, and combines them into
>> a single "boot_aggregate" as the first entry in the IMA list. For full
>> attestation, a user level program needs access to both IMA's
>> boot aggregate, and to the detailed TPM event log upon which
>> the aggregate is based. So IMA does not itself access the logs,
>> but the boot aggregate is less useful without them.
>>     
>
> So users of IMA in userspace may want TPM.  Shouldn't the kernel really
> have this as a depends/select in the TPM code?  This isn't IMA specific,
> it's TPM specific.  Obviously I'm not a fan of the spurious ACPI
> requirement in the IMA code.  How about a 'CONFIG_TPM_BIOS_LOG' or
> something which selects ACPI?  We'll see what Rajiv thinks.
>
>   
I like it, makes no sense to make IMA depend on ACPI just because a
lower layer does instead of making depend on this layer itself (the
TCG_TPM).
>> As a separate issue, IMA requires the TPM driver to be compiled in
>> (not loaded as a module) so it is available at IMA initialization, and
>> the driver apparently requires ACPI in this case. I believe Rajiv
>> will comment more on this.
>>     
>
> I know it's required to be built in.  Didn't know that required ACPI,
> but if so, that's a good reason to push this to the TPM code and get it
> out of the IMA code....
>
>   
The tpm.c code doesn't depend on ACPI actually, tpm_bios.c functions
called there have their proper dummy stubs in tpm.h in case ACPI isn't
selected.

However, by default, TPM_TIS depends on PNP to register the device,
which depends on ISA || ACPI. What's wrong there is that the device can
also be registered as a platform device providing the force module
option, therefore not requiring any of the PNP functions and structs,
and still needs PNP to be built due the Kconfig 'depends on PNP' entry.

On the attempt to push ACPI/PNP dependency into TPM code, I'm willing to
make the force option's default value and the PNP related code depend on
CONFIG_PNP and remove the PNP dependency in Kconfig.

Thanks,
Rajiv

