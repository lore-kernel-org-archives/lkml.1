Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab0BTPiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 10:38:12 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:45416 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab0BTPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 10:38:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=cUH/4snmoqTXR6aT4DEcBsAAWV3Pw9SSzHwwYXCBaxs8u8aqUffY9Gzktnzzo1PQyf
         hB8SZT1at2GAnaDg0ZovtmOAmKJtCHKvcQY2CWvKjNGDdBlrUqvnvjA2qGcgoG6kcjTq
         IsHryGalpsMdxhY8Kdez8lI4o7PH3Mut6BP9U=
Date: Sat, 20 Feb 2010 23:40:49 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: sysfs lockdep complaint
Message-ID: <20100220154049.GM3000@hack>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net> <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com> <1266664814.11514.5.camel@jlt3.sipsolutions.net> <20100220135122.GB3000@hack> <1266674493.18465.9.camel@jlt3.sipsolutions.net> <20100220150327.GG3000@hack> <1266678496.32309.1.camel@jlt3.sipsolutions.net> <20100220152010.GI3000@hack> <1266679687.17363.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1266679687.17363.1.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 04:28:07PM +0100, Johannes Berg wrote:
>On Sat, 2010-02-20 at 23:20 +0800, Américo Wang wrote:
>> On Sat, Feb 20, 2010 at 04:08:16PM +0100, Johannes Berg wrote:
>> >On Sat, 2010-02-20 at 23:03 +0800, Américo Wang wrote:
>> >
>> >>  	fct->fan_type = pwm_fan;
>> >>  	fct->ctrl.type = pwm_fan ? WF_CONTROL_PWM_FAN :
>> WF_CONTROL_RPM_FAN;
>> >> +	sysfs_attr_init(&fct->ctrl.attr);
>> >
>> >ah, needs to be "ctrl.attr.attr".
>> >
>> 
>> Ouch, right... Updated.
>
>I have this now, and that removed all the warnings:
>

Excellent!

You can send this as a normal patch to Erich and Greg, with me Cc'ed. :)

Thanks much!


>---
> drivers/macintosh/windfarm_core.c         |    1 +
> drivers/macintosh/windfarm_smu_controls.c |    1 +
> kernel/module.c                           |    3 +++
> 3 files changed, 5 insertions(+)
>
>--- wireless-testing.orig/drivers/macintosh/windfarm_smu_controls.c	2010-02-20 16:05:55.738721565 +0100
>+++ wireless-testing/drivers/macintosh/windfarm_smu_controls.c	2010-02-20 16:07:51.996717974 +0100
>@@ -173,6 +173,7 @@ static struct smu_fan_control *smu_fan_c
> 
> 	fct->fan_type = pwm_fan;
> 	fct->ctrl.type = pwm_fan ? WF_CONTROL_PWM_FAN : WF_CONTROL_RPM_FAN;
>+	sysfs_attr_init(&fct->ctrl.attr.attr);
> 
> 	/* We use the name & location here the same way we do for SMU sensors,
> 	 * see the comment in windfarm_smu_sensors.c. The locations are a bit
>--- wireless-testing.orig/drivers/macintosh/windfarm_core.c	2010-02-20 16:15:14.701580166 +0100
>+++ wireless-testing/drivers/macintosh/windfarm_core.c	2010-02-20 16:15:38.416369684 +0100
>@@ -321,6 +321,7 @@ int wf_register_sensor(struct wf_sensor 
> 	kref_init(&new_sr->ref);
> 	list_add(&new_sr->link, &wf_sensors);
> 
>+	sysfs_attr_init(&new_sr->attr.attr);
> 	new_sr->attr.attr.name = new_sr->name;
> 	new_sr->attr.attr.mode = 0444;
> 	new_sr->attr.show = wf_show_sensor;
>--- wireless-testing.orig/kernel/module.c	2010-02-20 16:16:52.740706797 +0100
>+++ wireless-testing/kernel/module.c	2010-02-20 16:22:52.499698256 +0100
>@@ -1085,6 +1085,7 @@ static void add_sect_attrs(struct module
> 		sect_attrs->nsections++;
> 		sattr->mattr.show = module_sect_show;
> 		sattr->mattr.store = NULL;
>+		sysfs_attr_init(&sattr->mattr.attr);
> 		sattr->mattr.attr.name = sattr->name;
> 		sattr->mattr.attr.mode = S_IRUGO;
> 		*(gattr++) = &(sattr++)->mattr.attr;
>@@ -1178,6 +1179,7 @@ static void add_notes_attrs(struct modul
> 		if (sect_empty(&sechdrs[i]))
> 			continue;
> 		if (sechdrs[i].sh_type == SHT_NOTE) {
>+			sysfs_bin_attr_init(nattr);
> 			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
> 			nattr->attr.mode = S_IRUGO;
> 			nattr->size = sechdrs[i].sh_size;
>@@ -1250,6 +1252,7 @@ int module_add_modinfo_attrs(struct modu
> 		if (!attr->test ||
> 		    (attr->test && attr->test(mod))) {
> 			memcpy(temp_attr, attr, sizeof(*temp_attr));
>+			sysfs_attr_init(&temp_attr->attr);
> 			error = sysfs_create_file(&mod->mkobj.kobj,&temp_attr->attr);
> 			++temp_attr;
> 		}
>
>
>johannes
>

-- 
Live like a child, think like the god.
 
