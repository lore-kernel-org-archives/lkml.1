Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZBOTfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZBOTfg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZBOTf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:35:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:1167 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbZBOTf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:35:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cp2OvJ+IjuoB4zTqmNADvAQkFXjNk3ZVLFOk9yYXdzU0RqyBVBbex2fqi7nLucy+ZL
         X5Np/t4Wr81IF4yLv8AKeoSMO1OLdq7Be0CtjDuBeq5bixL5p7zGYXup9+6TX/aQN83D
         e1o4R4tQqEtBQWi43kqD5woDwZeA8K/qXA54I=
Date: Sun, 15 Feb 2009 20:35:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Poking ieee80211_default_rc_algo causes kernel lockups
Message-ID: <20090215193522.GA5790@nowhere>
References: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 04:09:57PM +0000, Sitsofe Wheeler wrote:
> Hi,
> 
> As mentioned on
> http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/d4a6ce26360613fa/b362792a2debced6?#b362792a2debced6
> , poking /sys/module/mac80211/parameters/ieee80211_default_rc_algo and
> then trying to read values back is currently causing the kernel to go
> funny. E.g.
> echo blah > /sys/module/mac80211/parameters/ieee80211_default_rc_algo
> cat /sys/module/mac80211/parameters/ieee80211_default_rc_algo
> 
> Causes 2.6.29rc5 on my EeePC 900 to lock up.
> 
> -- 
> Sitsofe
> 


On Sun, Feb 15, 2009 at 04:09:57PM +0000, Sitsofe Wheeler wrote:
> Hi,
> 
> As mentioned on
> http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/d4a6ce26360613fa/b362792a2debced6?#b362792a2debced6
> , poking /sys/module/mac80211/parameters/ieee80211_default_rc_algo and
> then trying to read values back is currently causing the kernel to go
> funny. E.g.
> echo blah > /sys/module/mac80211/parameters/ieee80211_default_rc_algo
> cat /sys/module/mac80211/parameters/ieee80211_default_rc_algo
> 
> Causes 2.6.29rc5 on my EeePC 900 to lock up.
> 

I think I've found something:

When you set a new value to a module parameter through
sysfs, here is what happens (traced with the function_graph_tracer,
I've zapped a lot of entries to keep it clear)


 1)               |  sys_open() {
 1)               |            sysfs_open_file() {
 1)               |              kmem_cache_alloc() {
 1)   0.609 us    |                __might_sleep();
 1)   2.046 us    |              }
 1) + 58.976 us   |            }
 1) ! 471.823 us  |  }


The file is opened here, and sysfs will allocate a private buffer for this
file...


 1)               |  sys_write() {
 1)               |    vfs_write() {
 1)               |      sysfs_write_file() {
 1) + 26.446 us   |        get_zeroed_page();
 1)   0.789 us    |        sysfs_get_active_two();
 1)               |        module_attr_store() {
 1)               |          param_attr_store() {
 1)   5.625 us    |            param_set_charp();
 1)   7.279 us    |          }
 1)   8.919 us    |        }
 1)   4.113 us    |      }
 1) + 62.502 us   |    }
 1) + 64.961 us   |  }

Then we go to write the file, the buffer we allocated is used to store what
the user gave us as the new value of the module parameter.

This filled buffer is relayed to the module parameter and the address of the buffer
is directly assigned to the pointer of the module parameter:

int param_set_charp(const char *val, struct kernel_param *kp)
{
	[...]
	*(char **)kp->arg = (char *)val;
	return 0;
}

At this stage, all is good.

But just after we close the file:


 1)               |            sysfs_release() {
 1)               |              kfree() {
 1)   1.105 us    |                __phys_addr();
 1)   2.842 us    |              }
 1)               |              free_pages() {
 1)   0.609 us    |                __phys_addr();
 1)               |                __free_pages() {
 1)               |                  free_hot_page() {
 1)               |                    free_hot_cold_page() {
 1)   1.113 us    |                      get_pageblock_flags_group();
 1)   3.061 us    |                    }
 1)   4.466 us    |                  }
 1)   5.744 us    |                }
 1)   8.166 us    |              }
 1)               |              kfree() {
 1)   0.601 us    |                __phys_addr();
 1)   2.052 us    |              }
 1) + 18.686 us   |            }

The buffer we just assigned to the module parameter is freed. So we can't reuse it later,
but that's what is done later when we read it, since this bad address is dereferenced:

int param_get_charp(char *buffer, struct kernel_param *kp)
{
	return sprintf(buffer, "%s", *((char **)kp->arg));
}

So the problem seems not related to mac80211 but actually to module parameter management.
I'm not sure what is the right fix.

I guess we should use the following field in struct kernel_param:
struct kparam_string *str;

But this implies that string module params must not be simply pointers but static arrays.
Although I find it a bit insane to modify a string parameter at runtime.

The string is parsed by a module on load but not after, so a callback given by the module
seems to me more sane...


