Return-Path: <linux-kernel-owner+w=401wt.eu-S1762156AbYC0WYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156AbYC0WYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 18:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbYC0WYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 18:24:08 -0400
Received: from gw.goop.org ([64.81.55.164]:60402 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586AbYC0WYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 18:24:07 -0400
Message-ID: <47EC1E75.6090102@goop.org>
Date: Thu, 27 Mar 2008 15:23:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: Trying to make use of hotplug memory for xen balloon driver
References: <47EAD83A.2000000@goop.org> <1206577595.7883.26.camel@nimitz.home.sr71.net>
In-Reply-To: <1206577595.7883.26.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> The flags being all null looks highly suspicious to me.
>
> Once you've done an add_memory(), the new sections should show up
> in /sys.  Do you see them in there?
>
> Once they show up, you can online them with:
>
> 	echo online > /sys/devices/system/memory/memoryXXX/state
>
> That's what actually goes and mucks with the 'struct zone's and the
> pgdats to expand them.  It will also call online_page() on the whole
> range.  I think you're trying to do this manually, and missing part of
> it.  

Hm, actually this is precisely the wrong thing to do in this case.  When 
the balloon driver adds a new section of hotplug memory, its doing it to 
get the page structures, but there's no actual memory backing those 
pages.  The memory only comes into existence on a page-by-page basis 
when the balloon driver gets memory from the hypervisor and attaches it 
to each page (the balloon driver uses online_page() on each page as its 
ready).

If the user does a mass online via /sys the system explodes because it 
onlines a large number of pages which have no backing memory.  Since 
none of those pages can be mapped, the kernel explodes in a variety of 
interesting ways.

So I'd really like to inhibit the sysfs interface on these sections.  
Thoughts?

Thanks,
    J
