Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbYACJTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbYACJTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 04:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYACJTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 04:19:38 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:40678 "EHLO
	server1.example.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752899AbYACJTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 04:19:37 -0500
Message-ID: <477CA8A8.2090201@nigel.suspend2.net>
Date: Thu, 03 Jan 2008 20:19:36 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: freeze vs freezer
References: <4744FD87.7010301@goop.org> <20080102160234.GA17070@ucw.cz> <477C0258.8080609@nigel.suspend2.net> <200801022304.19279.rjw@sisk.pl>
In-Reply-To: <200801022304.19279.rjw@sisk.pl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Rafael J. Wysocki wrote:
> On Wednesday, 2 of January 2008, Nigel Cunningham wrote:
>> Pavel Machek wrote:
>>>>>>>> So how do you handle threads that are blocked on I/O or a lock  
>>>>>>>> during the system freeze process, then?
>>>>>>> We wait until they can continue.
>>>>>> So if I have a process blocked on an unavilable NFS mount, I can't
>>>>>> suspend?
>>>>> That's correct, you can't.
>>>>>
>>>>> [And I know what you're going to say. ;-)]
>>>> Why exactly does suspend/hibernation depend on "TASK_INTERRUPTIBLE"  
>>>> instead of a zero preempt_count()?  Really what we should do is just  
>>>> iterate over all of the actual physical devices and tell each one  
>>>> "Block new IO requests preemptably, finish pending DMA, put the  
>>>> hardware in low-power mode, and prepare for suspend/hibernate".  As  
>>>> long as each driver knows how to do those simple things we can have  
>>>> an entirely consistent kernel image for both suspend and for  
>>>> hibernation.
>>> "each driver" means this is a lot of work. But yes, that is probably
>>> way to go, and patch would be welcome.
>> Yes, that does work. It's what I've done in my (preliminary) support for
>> fuse.
> 
> Hmm, can you please elaborate a bit?

Sorry. I wasn't very unambiguous, was I? And I'm not sure now whether
you're meaning "How does fuse support relate to freezing block devices?"
or "What's this about fuse support?". Let me therefore seek to answer
both questions:

Higher level, I know (filesystems rather than block devices), but I was
meaning the general concept of blocking new requests and completing
existing ones worked fine for the supposedly impossible fuse support.

Re fuse support, let me start by saying "I know this doesn't handle all
situations, but I think it's a good enough proof-of-concept implementation".

I added some simple hooks to the code for submitting new work to fuse
threads.

#define FUSE_MIGHT_FREEZE(superblock, desc) \
do { \
       int printed = 0; \
       while(superblock->s_frozen != SB_UNFROZEN) { \
               if (!printed) { \
                       printk("%d frozen in " desc ".\n", current->pid); \
                       printed = 1; \
               } \
               try_to_freeze(); \
               yield(); \
       } \
} while (0)

On top of this, I made a (too simple at the moment) freeze_filesystems
function which iterates through &super_blocks in reverse order, freezing
fuse filesystems or ordinary ones. I say 'too simple' because it doesn't
currently allow for the possibility of someone mounting (say) ext3 on
fuse, but that would just be an extension of what's already done.

The end result is:

int freeze_processes(void)
{
        int error;

        printk(KERN_INFO "Stopping fuse filesystems.\n");
        freeze_filesystems(FS_FREEZER_FUSE);
        freezer_state = FREEZER_FILESYSTEMS_FROZEN;
        printk(KERN_INFO "Freezing user space processes ... ");
        error = try_to_freeze_tasks(FREEZER_USER_SPACE);
        if (error)
                goto Exit;
        printk(KERN_INFO "done.\n");

        sys_sync();
        printk(KERN_INFO "Stopping normal filesystems.\n");
        freeze_filesystems(FS_FREEZER_NORMAL);
        freezer_state = FREEZER_USERSPACE_FROZEN;
        printk(KERN_INFO "Freezing remaining freezable tasks ... ");
        error = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
        if (error)
                goto Exit;
        printk(KERN_INFO "done.");
        freezer_state = FREEZER_FULLY_ON;
 Exit:
        BUG_ON(in_atomic());
        printk("\n");
        return error;
}

Sorry if that's more info than you wanted.

Nigel
