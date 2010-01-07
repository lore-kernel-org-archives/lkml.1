Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540Ab0AGBPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab0AGBPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153Ab0AGBPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:15:07 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:44290 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab0AGBPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:15:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aOjPBFuT9XUajlasmgtw1PdAk5U4FQegsAUD2iOSONpUkagAfoJxxmezUt5BF8ziyf
         SSPYCeaPkcsQ3ycT0pA5feUSoXtZPcesKVfxalhtt2DV/MBZNZjJ9ZkNxaOV3KLLHZqL
         iLqKXYaJaMOMZ6++Y8/kYlOQBHXByZgOYHz1o=
Message-ID: <4B453594.3090501@gmail.com>
Date: Wed, 06 Jan 2010 19:15:00 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christian Hofstaedtler <ch@zeha.at>,
       x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
References: <20100104162114.GA30113@percival.namespace.at> <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain> <4B4225B3.8070705@zytor.com> <20100104174558.158cd512@infradead.org> <20100106143640.GB13984@srcf.ucam.org> <alpine.LFD.2.00.1001061321260.4086@localhost.localdomain> <20100106193608.GA21447@srcf.ucam.org> <alpine.LFD.2.00.1001061504110.4086@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001061504110.4086@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2010 02:22 PM, Len Brown wrote:
>>> using _OSI is not "a similar method to Windows".
>>> The BIOS does not need to invoke _OSI to determine if
>>> it should expose a properly functioning ACPI reset or not.
>>> Windows XP simply demanded it, and the box failed WHQL
>>> if it did not work.
>>
>> http://download.microsoft.com/download/7/E/7/7E7662CF-CBEA-470B-A97E-CE7CE0D98DC2/WinACPI_OSI.docx
>> was what I was referring to:
>>
>> "By using the _OSI method, ASL writers can easily determine the version
>> of the ACPI interfaces that the host operating system supports. This
>> versioning method provides a solution for creating firmware that can
>> support future operating systems and enable the operating system to
>> change behavior based on the requested interface levels."
>>
>> We know that this is used for deciding whether or not to block system IO
>> accesses, but it wouldn't surprise me if it's also used to determine
>> other functionality like whether or not the ACPI interface is used for
>> rebooting.
>
> I've looked at _OSI use in over a hundred DSDTs and never
> seen run-time re-configuration of reset support.
>
> I do not think the BIOS has a run-time decision to make here.
> If a box is designed to support Windows XP and newer, it is
> likely that ACPI_RESET is simply valid and XP blindly uses it.
> If reset fails, the box doesn't pass WHQL and the box is fixed.
> If W2K is run on that box, ACPI_RESET is still valid, just that
> W2K chooses to not write to it.
>
>>> Further, there is no _guarantee_ that a BIOS will invoke _OSI
>>> at all, let alone a _rule_ for what _OSI() strings the BIOS
>>> will choose to query to trigger its Windows specific
>>> compatibility hooks -- even if common practice is for
>>> a desktop BIOS to evaluate _OSI strings in sequence
>>> up throught he most recent version of Windows it
>>> knows about...
>>
>> It's effectively guaranteed if the system is validated with Windows.
>
> today's common industry practice != future guarantee
>
> We can't rely on blind use of _OSI to mean "new enough", since
> it was supported back in W2K era.  That means we have to parse
> the OSI strings.  But what happens when a BIOS writer decides to
> evaluate _OSI("Windows Future") without evaluating any of the
> old strings we know about?  We would disable ACPI reset on such
> a future box?

Well, the use of such OSI calls to indicate the BIOS supports 
OS-specific features is explicitly recommended by Microsoft, i.e. see 
the document linked at 
http://www.microsoft.com/whdc/system/pnppwr/powermgmt/WinACPI_OSI.mspx :

"Place the routine that identifies the operating system in an _INI 
method under the \_SB scope so that _OSI can run as early as possible. 
This placement is important because the operating system makes features 
available based on the string argument to the _OSI method."

Also from http://www.microsoft.com/taiwan/whdc/archive/BIOSAML.mspx :

"By passing the string "Windows 2001" into the _OSI method, the BIOS 
indicates to the operating system that the BIOS is aware of and 
compatible with the ACPI implementation and feature set of Windows XP."

They don't explicitly say how to do it, but the implication is that one 
should use the sort of method I've seen in various BIOSes, where it 
starts with checking _OSI on the newest Windows version and tries all 
known older Windows versions, and stops when it finds the first one that 
succeeds..
