Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbZGKM5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbZGKM5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 08:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbZGKM5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 08:57:39 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:42107 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZGKM5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 08:57:38 -0400
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jul 2009 08:57:38 EDT
Subject: Re: what means "module_param(channel_mask, channel_mask, 0644)"?
From: Paul Bolle <pebolle@tiscali.nl>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0907110658370.4257@localhost>
References: <alpine.LFD.2.00.0907110658370.4257@localhost>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 14:41:37 +0200
Message-Id: <1247316097.7262.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.3 (2.27.3-3.kb.1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-11 at 07:01 -0400, Robert P. J. Day wrote:
> researching my next newbie column about module parameters and i ran
> across the following:
> 
> drivers/input/misc/ati_remote2.c:module_param(channel_mask, channel_mask, 0644);
> drivers/input/misc/ati_remote2.c:module_param(mode_mask, mode_mask, 0644);
> 
> i have no idea what it means to have the second (type) field of
> module_param() simply repeat the name of the parameter.  is this some
> strange magic?  those two names don't *appear* to be typedef'ed
> anywhere i can see.

See include/linux/moduleparam.h:
    /* Helper functions: type is byte, short, ushort, int, uint, long,
       ulong, charp, bool or invbool, or XXX if you define param_get_XXX,
       param_set_XXX and param_check_XXX. */
    #define module_param_named(name, value, type, perm)                        \
            param_check_##type(name, &(value));                                \
            module_param_call(name, param_set_##type, param_get_##type, &value, perm); \
            __MODULE_PARM_TYPE(name, #type)

    #define module_param(name, type, perm)                          \
            module_param_named(name, name, type, perm)

And in drivers/input/misc/ati_remote2.c we find:
    #define param_check_channel_mask(name, p) __param_check(name, p, unsigned in
    #define param_set_channel_mask ati_remote2_set_channel_mask
    #define param_get_channel_mask ati_remote2_get_channel_mask
    module_param(channel_mask, channel_mask, 0644);
    [...]
    #define param_check_mode_mask(name, p) __param_check(name, p, unsigned int)
    #define param_set_mode_mask ati_remote2_set_mode_mask
    #define param_get_mode_mask ati_remote2_get_mode_mask
    module_param(mode_mask, mode_mask, 0644);

To me that looks like two implementations of the three param_*_XXX
functions described in the comment quoted above.

Does that answer your question?

Regards,


Paul Bolle

