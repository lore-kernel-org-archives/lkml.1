Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbZD2FUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbZD2FUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZD2FTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:19:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:34072 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZD2FTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:19:53 -0400
Message-ID: <49F7E374.7060103@gawab.com>
Date: Tue, 28 Apr 2009 22:19:48 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Eric Anholt <eric@anholt.net>
CC: lkml <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [.30-rc2 regression] garbled screen on video
References: <49F10D49.5010604@gawab.com> <1240942714.13997.71.camel@gaiman.anholt.net>
In-Reply-To: <1240942714.13997.71.camel@gaiman.anholt.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Anholt wrote:
> On Thu, 2009-04-23 at 17:52 -0700, Justin Madru wrote:
>   
>> Hi everyone,
>>
>> Summary:
>> After playing a video for a little bit, the screen gets garbled. The 
>> only way to fix it is to
>> switch to a virtual console and then back. The screen is fixed but 
>> unfortunately only for
>> less than a few minuets and the screen gets corrupted again.
>>
>> Effected Version: 2.6.30-rc2+
>> Picture showing a corrupt screen: 
>> http://ecs.fullerton.edu/~cs351a15/badscreen.jpg
>>
>> My System:
>> Ubuntu 9.4 with 943/940GML Express Integrated Graphics Controller 
>> [8086:27a2]
>> UXA/GEM/DRI2 enable. Full info at 
>> http://jdserver.homelinux.org/bugreports/004/
>>
>> Syslog Messages:
>> None, but switching virtual consoles gives
>> [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for 
>> disabled pipe 0
>> But I think that is another bug introduced with .30-rc1.
>>     
>
> Interesting.  Could you open a bug at bugs.freedesktop.org against xorg,
> driver/intel, to be sure this doesn't get lost?
>
> However, I suspect that the commit in question isn't causing your issue,
> but is just when tiling got reenabled on your platform so you got to see
> other (likely userland) bugs.  To test, you could revert the patch you
> bisected to and just apply one of the hunks with a little tweak:
>
> diff --git a/drivers/gpu/drm/i915/i915_gem_tiling.c b/drivers/gpu/drm/i915/i915_gem_tiling.c
> index 6be3f92..f27e523 100644
> --- a/drivers/gpu/drm/i915/i915_gem_tiling.c
> +++ b/drivers/gpu/drm/i915/i915_gem_tiling.c
> @@ -127,8 +129,8 @@ i915_gem_detect_bit_6_swizzle(struct drm_device *dev)
>  				swizzle_y = I915_BIT_6_SWIZZLE_9_11;
>  			} else {
>  				/* Bit 17 swizzling by the CPU in addition. */
> -				swizzle_x = I915_BIT_6_SWIZZLE_UNKNOWN;
> -				swizzle_y = I915_BIT_6_SWIZZLE_UNKNOWN;
> +				swizzle_x = I915_BIT_6_SWIZZLE_9_10;
> +				swizzle_y = I915_BIT_6_SWIZZLE_9;
>  			}
>  			break;
>  		}
>
> You'll get typical swizzling corruption if any tiled buffers get swapped
> out, but that shouldn't happen because Ubuntu 9.04 is stuck with DRI1 so
> all tiled buffers are pinned.  Note that DRI1 with compiz has many
> graphical corruption and stability issues that are fixed with DRI2, but
> I'm not sure that what you're seeing is one of those.
>
>   
I had UXA enabled when I get the screen corruption. And kernels before 
2.6.30-rc2
don't have the screen corruption. Ubuntu 9.4 has intel 2.6.3 driver I think.

> If that patch doesn't make things work, then to fix a giant pile of
> userland bugs that might account for it, update to the 2.7.0 2D driver
> and enable UXA, which will get you DRI2.
>
> If the revert + small diff fixes things, I'm interested in seeing the
> output of either reg_dumper from a compile of the 2D driver or a printk
> of dcc in that function, combined with a screenshot of mesa's readpix
> demo, on master (no reverts or anything).
>
>   
So do I apply your patch with the current revert still inplace?

And where do I find the reg_dumper, dcc printk and the mesa readpix demo?

Justin Madru
