Return-Path: <linux-kernel-owner+w=401wt.eu-S965137AbXAWNuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137AbXAWNuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 08:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965140AbXAWNuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 08:50:16 -0500
Received: from puma.cosy.sbg.ac.at ([141.201.2.23]:43333 "EHLO
	puma.cosy.sbg.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965120AbXAWNuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 08:50:14 -0500
Message-ID: <45B61287.1060206@cosy.sbg.ac.at>
Date: Tue, 23 Jan 2007 14:49:59 +0100
From: Michael Noisternig <mnoist@cosy.sbg.ac.at>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Joel Becker <Joel.Becker@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: configfs: return value for drop_item()/make_item()?
References: <45AF6D0C.8020600@cosy.sbg.ac.at> <20070118221249.GO27360@ca-server1.us.oracle.com> <45B4AF98.2080407@cosy.sbg.ac.at> <20070123011316.GC9422@ca-server1.us.oracle.com>
In-Reply-To: <20070123011316.GC9422@ca-server1.us.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> If you argue that they are in fact created by the user because they are 
>> a direct result of a user action, then I can apply the same argument to 
>> this one example:
>> ...
>>> This is precisely what configfs is designed to forbid. The kernel
>>> does not, ever, create configfs objects on its own. It does it as a
>>> result of userspace action.
>> No. The sub-directory only appears as a direct result of the user 
>> writing a value into the 'type' attribute. ;-)
> 
> 	Ok, you're stretching the metaphor.  Writing a value to a "type"
> attribute is, indeed, a userspace action.  However, configfs' contract
> is that only mkdir(2) creates objects.
> 	We're not trying to create the do-everything-kitchen-sink system
> here.  That way lies the problems we're trying to avoid.  That's why
> configfs has a specific contract it provides to (a) userspace and (b)
> client drivers.

Ok, so it's a design decision about configfs. I'll accept that. :)

>>> you're never going to get it from configfs. You should be using
>>> sysfs.
>> Hardly. sysfs doesn't allow the user creating directories. :>
> 
> 	sysfs certainly supports your "echo b > type" style of object
> creation.  You're type_file->store() method gets a "b" in the buffer and
> then does sysfs_mkdir() of your new object directory.  Here, the kernel
> is creating the new object (the directory).

Sorry, I wasn't clear. I meant that it's not possible to let the user 
create the parent directory via mkdir(2) within sysfs. I.e.
# mkdir object  <-- create object/, configfs only
# ls object
type
# echo b > object/type  <-- create b/, sysfs only
# ls object
type
b/
I cannot have both, sysfs and configfs functionality, within the same 
module configuration file system tree.

>> Hm, I had envisioned the user to fully configure the module via file 
>> system operations only. Now if the user is supposed to use a wrapper 
>> program this sheds a different light on all those 
>> what's-the-best-solution issues...
> 
> 	Certainly the user can do the configuration by hand.  It will
> always work.  But why make them understand your userspace<->kernel API
> when you can just provide a tool?  They're all going to script it up
> anyway.

Because the layout in say a user tool configuration file will look 
pretty much the same as the configfs tree.

Anyway, for something different now:

1. Is there any guarantee that strings passed to struct 
configfs_item_operations->store_attribute are 0-terminated? If not, 
there's not only potential for buffer overflows, but there already is - 
in configfs_example.c, using simple_strtoul().

2. A minor one: I realize that the CONFIGFS_ITEM_NAME_LEN value of 20 is 
taken over from sysfs, but in configfs a config_group now has 68 bytes 
of size, and assuming that many times one would simply kmalloc a simple 
struct config_group (without extending it) this would result in a waste 
of 60 bytes per malloc. Do you want to keep that #define or reduce it to 
16? Just a thought...

