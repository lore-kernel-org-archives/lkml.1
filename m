Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZALEgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZALEgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 23:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbZALEgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 23:36:44 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:39674 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZALEgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 23:36:44 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=Zh0AFbd5_N1bNxy9LMQA:9 a=cylitK_hICJDPMSk3GoA:7 a=-JyQe8hQmbL92fnaCbJ6o0I2lMEA:4 a=6BydmXIbXuwA:10 a=YcwOXTN8GhIA:10
Message-ID: <496AC8D9.1020402@shaw.ca>
Date: Sun, 11 Jan 2009 22:36:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: joseluismarchetti@yahoo.com.br
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: How to access a regular file from within a module ?
References: <20090111113053.42dc34ad@lxorguk.ukuu.org.uk> <207506.58372.qm@web34401.mail.mud.yahoo.com>
In-Reply-To: <207506.58372.qm@web34401.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jose Luis Marchetti wrote:
>> You don't generally get to do this. What are you
>> actually trying to achieve ?
> 
> Thanks for asking, there are two scenarios, the first one it would be to save an ethernet mac address, I got already emails with some work arounds for this. The other scenario is a little bit more complicated:
> 
> The system I am working now ( Kernel drivers + User applications ) performs cryptographic operations and it has a regulatory constraint: the user application have to undergo (expensive) certification everytime it is changed, but that is only true if the user application have access to the cryptographic keys, imagine a i++ is missing in the code, then we have to undergo the expensive certification for that.
> To avoid that I am trying to isolate the keys ( about 30 X 128bit keys, some of the keys chance everytime they are used ) and cryptographic algorithm from the application and putting them into the kernel so the application can not access that. Well you would say, saving the keys into a file is not a good security measure as it is accessible, the trick is that before saving the key into the file the kernel would encrypt the keys with another key ( KEK- Key Encryption Key ) and this KEK is stored into non volatile register inside the processor, so although the file is accessible it is encrypted.
> In this scenario the user application would request encryption/decryption services from the kernel, but it would never pass the Key to be used during the operation, it would pass a Key Id, like this: encrypt this data using key number 7 and Key number 7 is stored in a file ( encrypted ) the kernel could read.
> OK, some would say, the user application could read the key file and passed the encrypted key into the kernel function, the kernel would decrypt the encrypted key and do the operation, which is fine, but some of those keys change at every operation, so they have to be re-stored into the file at every operation, it would be nice to have it done by the kernel.

One big problem with file access in the kernel is that all the file 
operations require a process context - they need a process to stick the 
file descriptor into, to determine access permissions, etc. If you just 
start calling file operations from inside the kernel you're essentially 
stealing whatever process you're being called from's context for these 
operations, which is unlikely to be a good idea.

Not to mention, that accessing files from inside the kernel usually 
means the kernel enforces a policy on file naming/locations, and putting 
that sort of policy in the kernel is usually frowned upon.

In the case you're describing I'm not sure why you couldn't just store 
the keys in encrypted form inside the user app and have it write them 
back out when they change, instead of making the kernel do it..
