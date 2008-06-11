Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbYFKWGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbYFKWGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 18:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYFKWGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 18:06:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:58004 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYFKWGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 18:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=SPDKj/NxN4DcNo7y5XiOQIhNlOQ6Hl6Tps2ZSCv6XcWUnoQ09MPnPC7oWiOG2Vma9E
         GunLqiZQWmbqkPNIREbY4l0WVjzxaxjWACC66u5Yn5mV1lzthvzFaz2dC8zHuV+UxGDZ
         N4AiYAs2XWHrfVSLTPnqdA+XEjiPeLNDqG9wc=
Message-ID: <5a4c581d0806111506m31412b21lee7bb851dabe6576@mail.gmail.com>
Date: Thu, 12 Jun 2008 00:06:14 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [2.6.26-rc5-git2] WARNING: at kernel/lockdep.c:2658 check_flags+0x4c/0x128()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently upgraded my FC6 desktop to Fedora 9; with the
 latest nautilus RPM updates my VNC session went nuts
 with nautilus pegging the CPU for everything that breathed.

I now reverted to an earlier nautilus package, but during
 the peak CPU period my kernel spat this:

[314185.623294] ------------[ cut here ]------------
[314185.623414] WARNING: at kernel/lockdep.c:2658 check_flags+0x4c/0x128()
[314185.623514] Modules linked in: iptable_filter ip_tables x_tables
sunrpc ipv6 fuse snd_via82xx snd_ac97_codec ac97_bus snd_mpu401_uart
snd_rawmidi via686a hwmon parport_pc sg parport uhci_hcd ehci_hcd
[314185.623924] Pid: 12314, comm: nautilus Not tainted 2.6.26-rc5-git2 #4
[314185.624021]  [<c0115b95>] warn_on_slowpath+0x41/0x7b
[314185.624021]  [<c010de70>] ? do_page_fault+0x2c1/0x5fd
[314185.624021]  [<c0128396>] ? up_read+0x16/0x28
[314185.624021]  [<c010de70>] ? do_page_fault+0x2c1/0x5fd
[314185.624021]  [<c012fa33>] ? __lock_acquire+0xbb4/0xbc3
[314185.624021]  [<c012d0a0>] check_flags+0x4c/0x128
[314185.624021]  [<c012fa73>] lock_acquire+0x31/0x7d
[314185.624021]  [<c0128cf6>] __atomic_notifier_call_chain+0x30/0x80
[314185.624021]  [<c0128cc6>] ? __atomic_notifier_call_chain+0x0/0x80
[314185.624021]  [<c0128d52>] atomic_notifier_call_chain+0xc/0xe
[314185.624021]  [<c0128d81>] notify_die+0x2d/0x2f
[314185.624021]  [<c01043b0>] do_int3+0x1f/0x4d
[314185.624021]  [<c02f2d3b>] int3+0x27/0x2c
[314185.624021]  =======================
[314185.624021] ---[ end trace 1923f65a2d7bb246 ]---
[314185.624021] possible reason: unannotated irqs-off.
[314185.624021] irq event stamp: 488879
[314185.624021] hardirqs last  enabled at (488879): [<c0102d67>]
restore_nocheck+0x12/0x15
[314185.624021] hardirqs last disabled at (488878): [<c0102dca>]
work_resched+0x19/0x30
[314185.624021] softirqs last  enabled at (488876): [<c011a1ba>]
__do_softirq+0xa6/0xac
[314185.624021] softirqs last disabled at (488865): [<c010476e>]
do_softirq+0x57/0xa6

I didn't seem to find it with some googling, so here it is.

I was incidentally ltracing that process to try and find out
 what was gulping down that much CPU (sorry, no idea
 whether ltrace and the WARNING happened at the same
 time or which came first) and:

[root@donkey ~]# ltrace -c -p 12314
^C% time     seconds  usecs/call     calls      function
------ ----------- ----------- --------- --------------------
 78.22   28.837601      739425        39 g_cclosure_marshal_VOID__OBJECT
  6.53    2.407936      150496        16 eel_canvas_item_get_bounds
  5.82    2.145861        3461       620 g_type_check_instance_cast
  5.45    2.009936       71783        28 gdk_gc_set_rgb_fg_color
  1.13    0.416437         450       924 g_direct_hash
  0.48    0.175278         304       576 g_type_check_instance_is_a
  0.22    0.080984        5061        16 eel_canvas_item_set
  0.21    0.078327         349       224 eel_str_is_empty
  0.20    0.073830        4614        16 pango_layout_get_extents
  0.19    0.071272         456       156 g_object_unref
  0.19    0.070753        4422        16 gtk_icon_theme_choose_icon
  0.11    0.041811         140       297 g_direct_equal
  0.11    0.041042         513        80 g_hash_table_lookup
  0.09    0.034237         237       144 eel_canvas_item_get_type
  0.07    0.024834         253        98 g_free
  0.05    0.019926         176       113 g_object_ref
 [snipped stuff under 0.05]
------ ----------- ----------- --------- --------------------
100.00   36.868859                  4658 total

Ouch. And another ltrace several seconds later:

[root@donkey ~]# ltrace -c -p 12314
^C% time     seconds  usecs/call     calls      function
------ ----------- ----------- --------- --------------------
 98.55    6.777972     2259324         3 g_cclosure_marshal_VOID__VOID
  0.71    0.049092          79       616 g_direct_hash
  0.26    0.017639         430        41 g_object_unref
  0.14    0.009971          77       129 g_type_check_instance_cast
  0.07    0.004904        1226         4 gdk_pixbuf_get_height
  0.04    0.002583          75        34 gtk_widget_get_type
  0.03    0.001875         234         8 gdk_x11_get_xatom_by_name
  0.02    0.001681          80        21 g_type_check_class_cast
  0.02    0.001539         384         4 eel_gdk_draw_layout_with_drop_shadow
  0.02    0.001494          74        20 eel_canvas_item_get_type
  0.02    0.001238         123        10 gtk_widget_style_get
  0.01    0.000971          74        13 g_type_check_instance_is_a
  0.01    0.000920          76        12 g_object_ref
  0.01    0.000918         131         7 gdk_gc_new
  0.01    0.000748         187         4 gdk_draw_pixbuf
  0.01    0.000664          83         8 gdk_pixbuf_get_width
  0.01    0.000633          90         7 gdk_gc_set_rgb_fg_color
  0.01    0.000525          75         7 gtk_layout_get_type
  0.01    0.000522          74         7 eel_gdk_rgb_to_color
  0.01    0.000425          85         5 gtk_object_get_type
  0.00    0.000305          76         4 gdk_rectangle_intersect
  0.00    0.000305          76         4 floor
  0.00    0.000302          75         4 pango_layout_get_extents
  0.00    0.000232          77         3 eel_gdk_color_to_rgb
  0.00    0.000149          74         2 eel_gdk_color_is_dark
  0.00    0.000093          93         1 eel_get_widget_background
  0.00    0.000078          78         1 eel_background_get_type
  0.00    0.000078          78         1 eel_background_is_set
------ ----------- ----------- --------- --------------------
100.00    6.877856                   980 total


Yikes ! Enough. After that, the unavoidable downgrade...

[root@donkey ~]# rpm -Uvh --oldpackage /tmp/nautilus-2.22.2-7.fc9.i386.rpm

And stuff is back to decent - Xvnc under Fedora 9 is clearly
 slower than the same under Fedora 8, but the above
 nautilus behavior was rendering it unusable.

Box is my trusty noname K7-800, 512MB RAM; if there's
 anything else useful I might be able to provide, just ask.

Thanks,

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')
