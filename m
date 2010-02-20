Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0BTP2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 10:28:12 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:35399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab0BTP2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 10:28:10 -0500
Subject: Re: sysfs lockdep complaint
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20100220152010.GI3000@hack>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
	 <1266664814.11514.5.camel@jlt3.sipsolutions.net>
	 <20100220135122.GB3000@hack>
	 <1266674493.18465.9.camel@jlt3.sipsolutions.net>
	 <20100220150327.GG3000@hack>
	 <1266678496.32309.1.camel@jlt3.sipsolutions.net>
	 <20100220152010.GI3000@hack>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 16:28:07 +0100
Message-ID: <1266679687.17363.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 23:20 +0800, Américo Wang wrote:
> On Sat, Feb 20, 2010 at 04:08:16PM +0100, Johannes Berg wrote:
> >On Sat, 2010-02-20 at 23:03 +0800, Américo Wang wrote:
> >
> >>  	fct->fan_type = pwm_fan;
> >>  	fct->ctrl.type = pwm_fan ? WF_CONTROL_PWM_FAN :
> WF_CONTROL_RPM_FAN;
> >> +	sysfs_attr_init(&fct->ctrl.attr);
> >
> >ah, needs to be "ctrl.attr.attr".
> >
> 
> Ouch, right... Updated.

I have this now, and that removed all the warnings:

---
 drivers/macintosh/windfarm_core.c         |    1 +
 drivers/macintosh/windfarm_smu_controls.c |    1 +
 kernel/module.c                           |    3 +++
 3 files changed, 5 insertions(+)

--- wireless-testing.orig/drivers/macintosh/windfarm_smu_controls.c	2010-02-20 16:05:55.738721565 +0100
+++ wireless-testing/drivers/macintosh/windfarm_smu_controls.c	2010-02-20 16:07:51.996717974 +0100
@@ -173,6 +173,7 @@ static struct smu_fan_control *smu_fan_c
 
 	fct->fan_type = pwm_fan;
 	fct->ctrl.type = pwm_fan ? WF_CONTROL_PWM_FAN : WF_CONTROL_RPM_FAN;
+	sysfs_attr_init(&fct->ctrl.attr.attr);
 
 	/* We use the name & location here the same way we do for SMU sensors,
 	 * see the comment in windfarm_smu_sensors.c. The locations are a bit
--- wireless-testing.orig/drivers/macintosh/windfarm_core.c	2010-02-20 16:15:14.701580166 +0100
+++ wireless-testing/drivers/macintosh/windfarm_core.c	2010-02-20 16:15:38.416369684 +0100
@@ -321,6 +321,7 @@ int wf_register_sensor(struct wf_sensor 
 	kref_init(&new_sr->ref);
 	list_add(&new_sr->link, &wf_sensors);
 
+	sysfs_attr_init(&new_sr->attr.attr);
 	new_sr->attr.attr.name = new_sr->name;
 	new_sr->attr.attr.mode = 0444;
 	new_sr->attr.show = wf_show_sensor;
--- wireless-testing.orig/kernel/module.c	2010-02-20 16:16:52.740706797 +0100
+++ wireless-testing/kernel/module.c	2010-02-20 16:22:52.499698256 +0100
@@ -1085,6 +1085,7 @@ static void add_sect_attrs(struct module
 		sect_attrs->nsections++;
 		sattr->mattr.show = module_sect_show;
 		sattr->mattr.store = NULL;
+		sysfs_attr_init(&sattr->mattr.attr);
 		sattr->mattr.attr.name = sattr->name;
 		sattr->mattr.attr.mode = S_IRUGO;
 		*(gattr++) = &(sattr++)->mattr.attr;
@@ -1178,6 +1179,7 @@ static void add_notes_attrs(struct modul
 		if (sect_empty(&sechdrs[i]))
 			continue;
 		if (sechdrs[i].sh_type == SHT_NOTE) {
+			sysfs_bin_attr_init(nattr);
 			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
 			nattr->attr.mode = S_IRUGO;
 			nattr->size = sechdrs[i].sh_size;
@@ -1250,6 +1252,7 @@ int module_add_modinfo_attrs(struct modu
 		if (!attr->test ||
 		    (attr->test && attr->test(mod))) {
 			memcpy(temp_attr, attr, sizeof(*temp_attr));
+			sysfs_attr_init(&temp_attr->attr);
 			error = sysfs_create_file(&mod->mkobj.kobj,&temp_attr->attr);
 			++temp_attr;
 		}


johannes

