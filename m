Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbZJMQ4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbZJMQ4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbZJMQ4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:56:04 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:54239 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379AbZJMQ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:56:03 -0400
From: Frans Pop <elendil@planet.nl>
To: Ferenc Wagner <wferi@niif.hu>
Subject: Re: 2.6.32-rc4 ipw2200: oops on missing firmware
Date: Tue, 13 Oct 2009 18:55:24 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org,
       Reinette Chatre <reinette.chatre@intel.com>
References: <87hbu3h023.fsf@tac.ki.iif.hu>
In-reply-To: <87hbu3h023.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910131855.25878.elendil@planet.nl>
X-OriginalArrivalTime: 13 Oct 2009 16:55:26.0371 (UTC) FILETIME=[F6546F30:01CA4C25]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding relevant CCs. Original message follows.

==============
Hi,

See the screenshot at http://apt.niif.hu/ipw_oops.png.  During bootup,
initramfs-tools tried to load the ipw2200 module, but nobody fed it
the necessary firmware, so request_firmware timed out and the module
unload cleanup oopsed in device_pm_remove:

void device_pm_remove(struct device *dev)
{
        pr_debug("PM: Removing info for %s:%s\n",
                 dev->bus ? dev->bus->name : "No Bus",
                 kobject_name(&dev->kobj));
        mutex_lock(&dpm_list_mtx);
        list_del_init(&dev->power.entry);
        mutex_unlock(&dpm_list_mtx);
        pm_runtime_remove(dev);
}

00000a0a <device_pm_remove>:
 a0a:   55                      push   %ebp
 a0b:   89 e5                   mov    %esp,%ebp
 a0d:   53                      push   %ebx
 a0e:   89 c3                   mov    %eax,%ebx
 a10:   b8 08 00 00 00          mov    $0x8,%eax
 a15:   e8 fc ff ff ff          call   a16 <device_pm_remove+0xc>
 a1a:   8d 4b 5c                lea    0x5c(%ebx),%ecx
 a1d:   8b 53 5c                mov    0x5c(%ebx),%edx
 a20:   8b 43 60                mov    0x60(%ebx),%eax
 a23:   89 42 04                mov    %eax,0x4(%edx)
 a26:   89 10                   mov    %edx,(%eax)
 a28:   89 4b 5c                mov    %ecx,0x5c(%ebx)
 a2b:   89 4b 60                mov    %ecx,0x60(%ebx)
 a2e:   b8 08 00 00 00          mov    $0x8,%eax
 a33:   e8 fc ff ff ff          call   a34 <device_pm_remove+0x2a>
 a38:   89 d8                   mov    %ebx,%eax
 a3a:   e8 fc ff ff ff          call   a3b <device_pm_remove+0x31>
 a3f:   5b                      pop    %ebx
 a40:   5d                      pop    %ebp
 a41:   c3                      ret    

The offending IP translates to line a23, so the problem is edx being 0
at that point.  I'm not sure which struct device field has offset
0x5c, maybe power, but I'm lost at this point anyway.

I don't know whether it's a new bug or not, never did such insane
things previously.  rmmod ipw2200 definitely worked under 2.6.31, and
it's possible that it works under 2.6.32-rc4 too, I forgot to check
that (but will do so tonight).

--
Regards,
Feri.
