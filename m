Return-Path: <linux-kernel-owner+w=401wt.eu-S938588AbXHJQLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938588AbXHJQLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940346AbXHJQGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:06:24 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50409 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940249AbXHJQF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:05:58 -0400
Message-ID: <46BC8CEB.3020400@bull.net>
Date: Fri, 10 Aug 2007 18:06:03 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2][KVM] modify account_system_time() to add cputime
 to cpustat->guest
References: <46BC8B59.3060908@bull.net>
In-Reply-To: <46BC8B59.3060908@bull.net>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/08/2007 18:11:00,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/08/2007 18:11:01,
	Serialize complete at 10/08/2007 18:11:01
Content-Type: multipart/mixed;
 boundary="------------080200030005040507010703"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080200030005040507010703
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=ISO-8859-1

You can find attached to this email the patch to apply to procps-3.2.7[1]=
 to
allow "top(1)" to display the cpu guest time.

Laurent
[1] http://procps.sf.net/procps-3.2.7.tar.gz
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth

--------------080200030005040507010703
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 name="procps-proc_stat_guest"
Content-Disposition: inline;
 filename="procps-proc_stat_guest"

Index: procps-3.2.7/top.c
===================================================================
--- procps-3.2.7.orig/top.c	2007-08-08 16:13:17.000000000 +0200
+++ procps-3.2.7/top.c	2007-08-10 16:46:01.000000000 +0200
@@ -935,7 +935,8 @@
    cpus[Cpu_tot].x = 0;  // FIXME: can't tell by kernel version number
    cpus[Cpu_tot].y = 0;  // FIXME: can't tell by kernel version number
    cpus[Cpu_tot].z = 0;  // FIXME: can't tell by kernel version number
-   num = sscanf(buf, "cpu %Lu %Lu %Lu %Lu %Lu %Lu %Lu %Lu",
+   cpus[Cpu_tot].g = 0;  // FIXME: can't tell by kernel version number
+   num = sscanf(buf, "cpu %Lu %Lu %Lu %Lu %Lu %Lu %Lu %Lu %Lu",
       &cpus[Cpu_tot].u,
       &cpus[Cpu_tot].n,
       &cpus[Cpu_tot].s,
@@ -943,7 +944,8 @@
       &cpus[Cpu_tot].w,
       &cpus[Cpu_tot].x,
       &cpus[Cpu_tot].y,
-      &cpus[Cpu_tot].z
+      &cpus[Cpu_tot].z,
+      &cpus[Cpu_tot].g
    );
    if (num < 4)
          std_err("failed /proc/stat read");
@@ -960,9 +962,10 @@
       cpus[i].x = 0;  // FIXME: can't tell by kernel version number
       cpus[i].y = 0;  // FIXME: can't tell by kernel version number
       cpus[i].z = 0;  // FIXME: can't tell by kernel version number
-      num = sscanf(buf, "cpu%u %Lu %Lu %Lu %Lu %Lu %Lu %Lu %Lu",
+      cpus[i].g = 0;  // FIXME: can't tell by kernel version number
+      num = sscanf(buf, "cpu%u %Lu %Lu %Lu %Lu %Lu %Lu %Lu %Lu %Lu",
          &cpus[i].id,
-         &cpus[i].u, &cpus[i].n, &cpus[i].s, &cpus[i].i, &cpus[i].w, &cpus[i].x, &cpus[i].y, &cpus[i].z
+         &cpus[i].u, &cpus[i].n, &cpus[i].s, &cpus[i].i, &cpus[i].w, &cpus[i].x, &cpus[i].y, &cpus[i].z, &cpus[i].g
       );
       if (num < 4)
             std_err("failed /proc/stat read");
@@ -2879,10 +2882,11 @@
    // we'll trim to zero if we get negative time ticks,
    // which has happened with some SMP kernels (pre-2.4?)
 #define TRIMz(x)  ((tz = (SIC_t)(x)) < 0 ? 0 : tz)
-   SIC_t u_frme, s_frme, n_frme, i_frme, w_frme, x_frme, y_frme, z_frme, tot_frme, tz;
+   SIC_t u_frme, s_frme, n_frme, i_frme, w_frme, x_frme, y_frme, z_frme, g_frme, tot_frme, tz, u_tmp;
    float scale;
 
-   u_frme = cpu->u - cpu->u_sav;
+   u_tmp = cpu->u - cpu->g;
+   u_frme = TRIMz(u_tmp - cpu->u_sav);
    s_frme = cpu->s - cpu->s_sav;
    n_frme = cpu->n - cpu->n_sav;
    i_frme = TRIMz(cpu->i - cpu->i_sav);
@@ -2890,7 +2894,8 @@
    x_frme = cpu->x - cpu->x_sav;
    y_frme = cpu->y - cpu->y_sav;
    z_frme = cpu->z - cpu->z_sav;
-   tot_frme = u_frme + s_frme + n_frme + i_frme + w_frme + x_frme + y_frme + z_frme;
+   g_frme = cpu->g - cpu->g_sav;
+   tot_frme = u_frme + s_frme + n_frme + i_frme + w_frme + x_frme + y_frme + z_frme + g_frme;
    if (tot_frme < 1) tot_frme = 1;
    scale = 100.0 / (float)tot_frme;
 
@@ -2908,13 +2913,14 @@
          (float)w_frme * scale,
          (float)x_frme * scale,
          (float)y_frme * scale,
-         (float)z_frme * scale
+         (float)z_frme * scale,
+         (float)g_frme * scale
       )
    );
    Msg_row += 1;
 
    // remember for next time around
-   cpu->u_sav = cpu->u;
+   cpu->u_sav = u_tmp;
    cpu->s_sav = cpu->s;
    cpu->n_sav = cpu->n;
    cpu->i_sav = cpu->i;
@@ -2922,6 +2928,7 @@
    cpu->x_sav = cpu->x;
    cpu->y_sav = cpu->y;
    cpu->z_sav = cpu->z;
+   cpu->g_sav = cpu->g;
 
 #undef TRIMz
 }
Index: procps-3.2.7/top.h
===================================================================
--- procps-3.2.7.orig/top.h	2007-08-08 16:14:47.000000000 +0200
+++ procps-3.2.7/top.h	2007-08-08 17:01:45.000000000 +0200
@@ -211,8 +211,8 @@
 // calculations.  It exists primarily for SMP support but serves
 // all environments.
 typedef struct CPU_t {
-   TIC_t u, n, s, i, w, x, y, z; // as represented in /proc/stat
-   TIC_t u_sav, s_sav, n_sav, i_sav, w_sav, x_sav, y_sav, z_sav; // in the order of our display
+   TIC_t u, n, s, i, w, x, y, z, g; // as represented in /proc/stat
+   TIC_t u_sav, s_sav, n_sav, i_sav, w_sav, x_sav, y_sav, z_sav, g_sav; // in the order of our display
    unsigned id;  // the CPU ID number
 } CPU_t;
 
@@ -390,7 +390,7 @@
 #define STATES_line2x6  "%s\03" \
    " %#4.1f%% \02us,\03 %#4.1f%% \02sy,\03 %#4.1f%% \02ni,\03 %#4.1f%% \02id,\03 %#4.1f%% \02wa,\03 %#4.1f%% \02hi,\03 %#4.1f%% \02si\03\n"
 #define STATES_line2x7  "%s\03" \
-   "%#5.1f%%\02us,\03%#5.1f%%\02sy,\03%#5.1f%%\02ni,\03%#5.1f%%\02id,\03%#5.1f%%\02wa,\03%#5.1f%%\02hi,\03%#5.1f%%\02si,\03%#5.1f%%\02st\03\n"
+  "%#4.1f%%\02us,\03%#4.1f%%\02sy,\03%#4.1f%%\02ni,\03%#5.1f%%\02id,\03%#4.1f%%\02wa,\03%#4.1f%%\02hi,\03%#4.1f%%\02si,\03%#4.1f%%\02st\03,\02%#4.1f%%\02g\n"
 #ifdef CASEUP_SUMMK
 #define MEMORY_line1  "Mem: \03" \
    " %8luK \02total,\03 %8luK \02used,\03 %8luK \02free,\03 %8luK \02buffers\03\n"

--------------080200030005040507010703--
