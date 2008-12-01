Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbYLAVBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbYLAVBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYLAVBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:01:19 -0500
Received: from serrano.cc.columbia.edu ([128.59.29.6]:43226 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYLAVBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:01:17 -0500
Message-ID: <49345086.4@cs.columbia.edu>
Date: Mon, 01 Dec 2008 16:00:54 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Linus Torvalds <torvalds@osdl.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC v10][PATCH 09/13] Restore open file descriprtors
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>	 <1227747884-14150-10-git-send-email-orenl@cs.columbia.edu>	 <20081128112745.GR28946@ZenIV.linux.org.uk>	 <1228159324.2971.74.camel@nimitz>  <49344C11.6090204@cs.columbia.edu> <1228164873.2971.95.camel@nimitz>
In-Reply-To: <1228164873.2971.95.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Mon, 2008-12-01 at 15:41 -0500, Oren Laadan wrote:
>>>>> +   fd = cr_attach_file(file);      /* no need to cleanup 'file' below */
>>>>> +   if (fd < 0) {
>>>>> +           filp_close(file, NULL);
>>>>> +           ret = fd;
>>>>> +           goto out;
>>>>> +   }
>>>>> +
>>>>> +   /* register new <objref, file> tuple in hash table */
>>>>> +   ret = cr_obj_add_ref(ctx, file, parent, CR_OBJ_FILE, 0);
>>>>> +   if (ret < 0)
>>>>> +           goto out;
>>>> Who said that file still exists at that point?
>> Correct. This call should move higher up befor ethe call to cr_attach_file()
> 
> Is that sufficient?  It seems like we're depending on the fd's reference
> to the 'struct file' to keep it valid in the hash.  If something happens
> to the fd (like the other thread messing with it) the 'struct file' can
> still go away.
> 
> Shouldn't we do another get_file() for the hash's reference?

When a shared object is inserted to the hash we automatically take another
reference to it (according to its type) for as long as it remains in the
hash. See:  'cr_obj_ref_grab()' and 'cr_obj_ref_drop()'.  So by moving that
call higher up, we protect the struct file.

Oren.

