Return-Path: <linux-kernel-owner+w=401wt.eu-S934726AbYBTUos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726AbYBTUos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYBTUoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:44:39 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40997 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752966AbYBTUoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:44:37 -0500
Date: Wed, 20 Feb 2008 20:35:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vt_ioctl: Prepare for BKL push down
Message-ID: <20080220203533.66ecc951@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one could do with some eyeballs on it. In theory it simply wraps the
ioctl handler in lock/unlock_kernel ready for the lock/unlocks to be
pushed into specific switch values. To do that means changing the code to
return via a common exit path not all over the place as it does now,
hence the big diff

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/vt_ioctl.c linux-2.6.25-rc2-mm1/drivers/char/vt_ioctl.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/vt_ioctl.c	2008-02-19 11:01:43.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/vt_ioctl.c	2008-02-20 11:49:34.000000000 +0000
@@ -373,11 +373,17 @@
 	unsigned char ucval;
 	void __user *up = (void __user *)arg;
 	int i, perm;
-	
+	int ret = 0;
+
 	console = vc->vc_num;
+	
+	lock_kernel();
 
-	if (!vc_cons_allocated(console)) 	/* impossible? */
-		return -ENOIOCTLCMD;
+	if (!vc_cons_allocated(console)) { 	/* impossible? */
+		ret = -ENOIOCTLCMD;
+		goto out;
+	}
+		
 
 	/*
 	 * To have permissions to do most of the vt ioctls, we either have
@@ -391,15 +397,15 @@
 	switch (cmd) {
 	case KIOCSOUND:
 		if (!perm)
-			return -EPERM;
+			goto eperm;
 		if (arg)
 			arg = CLOCK_TICK_RATE / arg;
 		kd_mksound(arg, 0);
-		return 0;
+		break;
 
 	case KDMKTONE:
 		if (!perm)
-			return -EPERM;
+			goto eperm;
 	{
 		unsigned int ticks, count;
 		
@@ -412,7 +418,7 @@
 		if (count)
 			count = CLOCK_TICK_RATE / count;
 		kd_mksound(count, ticks);
-		return 0;
+		break;
 	}
 
 	case KDGKBTYPE:
@@ -435,14 +441,18 @@
 		 * KDADDIO and KDDELIO may be able to add ports beyond what
 		 * we reject here, but to be safe...
 		 */
-		if (arg < GPFIRST || arg > GPLAST)
-			return -EINVAL;
-		return sys_ioperm(arg, 1, (cmd == KDADDIO)) ? -ENXIO : 0;
+		if (arg < GPFIRST || arg > GPLAST) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = sys_ioperm(arg, 1, (cmd == KDADDIO)) ? -ENXIO : 0;
+		break;
 
 	case KDENABIO:
 	case KDDISABIO:
-		return sys_ioperm(GPFIRST, GPNUM,
+		ret = sys_ioperm(GPFIRST, GPNUM,
 				  (cmd == KDENABIO)) ? -ENXIO : 0;
+		break;
 #endif
 
 	/* Linux m68k/i386 interface for setting the keyboard delay/repeat rate */
@@ -450,19 +460,20 @@
 	case KDKBDREP:
 	{
 		struct kbd_repeat kbrep;
-		int err;
 		
 		if (!capable(CAP_SYS_TTY_CONFIG))
-			return -EPERM;
+			goto eperm;
 
-		if (copy_from_user(&kbrep, up, sizeof(struct kbd_repeat)))
-			return -EFAULT;
-		err = kbd_rate(&kbrep);
-		if (err)
-			return err;
+		if (copy_from_user(&kbrep, up, sizeof(struct kbd_repeat))) {
+			ret =  -EFAULT;
+			break;
+		}
+		ret = kbd_rate(&kbrep);
+		if (ret)
+			break;
 		if (copy_to_user(up, &kbrep, sizeof(struct kbd_repeat)))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		break;
 	}
 
 	case KDSETMODE:
@@ -475,7 +486,7 @@
 		 * need to restore their engine state. --BenH
 		 */
 		if (!perm)
-			return -EPERM;
+			goto eperm;
 		switch (arg) {
 		case KD_GRAPHICS:
 			break;
@@ -485,13 +496,14 @@
 		case KD_TEXT:
 			break;
 		default:
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 		if (vc->vc_mode == (unsigned char) arg)
-			return 0;
+			break;
 		vc->vc_mode = (unsigned char) arg;
 		if (console != fg_console)
-			return 0;
+			break;
 		/*
 		 * explicitly blank/unblank the screen if switching modes
 		 */
@@ -501,7 +513,7 @@
 		else
 			do_blank_screen(1);
 		release_console_sem();
-		return 0;
+		break;
 
 	case KDGETMODE:
 		ucval = vc->vc_mode;
@@ -513,11 +525,12 @@
 		 * these work like a combination of mmap and KDENABIO.
 		 * this could be easily finished.
 		 */
-		return -EINVAL;
+		ret = -EINVAL;
+		break;
 
 	case KDSKBMODE:
 		if (!perm)
-			return -EPERM;
+			goto eperm;
 		switch(arg) {
 		  case K_RAW:
 			kbd->kbdmode = VC_RAW;
@@ -534,10 +547,11 @@
 			compute_shiftstate();
 			break;
 		  default:
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 		tty_ldisc_flush(tty);
-		return 0;
+		break;
 
 	case KDGKBMODE:
 		ucval = ((kbd->kbdmode == VC_RAW) ? K_RAW :
@@ -557,28 +571,32 @@
 			set_vc_kbd_mode(kbd, VC_META);
 			break;
 		  default:
-			return -EINVAL;
+			ret = -EINVAL;
 		}
-		return 0;
+		break;
 
 	case KDGKBMETA:
 		ucval = (vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT);
 	setint:
-		return put_user(ucval, (int __user *)arg); 
+		ret = put_user(ucval, (int __user *)arg); 
+		break;
 
 	case KDGETKEYCODE:
 	case KDSETKEYCODE:
 		if(!capable(CAP_SYS_TTY_CONFIG))
-			perm=0;
-		return do_kbkeycode_ioctl(cmd, up, perm);
+			perm = 0;
+		ret = do_kbkeycode_ioctl(cmd, up, perm);
+		break;
 
 	case KDGKBENT:
 	case KDSKBENT:
-		return do_kdsk_ioctl(cmd, up, perm, kbd);
+		ret = do_kdsk_ioctl(cmd, up, perm, kbd);
+		break;
 
 	case KDGKBSENT:
 	case KDSKBSENT:
-		return do_kdgkb_ioctl(cmd, up, perm);
+		ret = do_kdgkb_ioctl(cmd, up, perm);
+		break;
 
 	case KDGKBDIACR:
 	{
@@ -586,26 +604,31 @@
 		struct kbdiacr diacr;
 		int i;
 
-		if (put_user(accent_table_size, &a->kb_cnt))
-			return -EFAULT;
+		if (put_user(accent_table_size, &a->kb_cnt)) {
+			ret = -EFAULT;
+			break;
+		}
 		for (i = 0; i < accent_table_size; i++) {
 			diacr.diacr = conv_uni_to_8bit(accent_table[i].diacr);
 			diacr.base = conv_uni_to_8bit(accent_table[i].base);
 			diacr.result = conv_uni_to_8bit(accent_table[i].result);
-			if (copy_to_user(a->kbdiacr + i, &diacr, sizeof(struct kbdiacr)))
-				return -EFAULT;
+			if (copy_to_user(a->kbdiacr + i, &diacr, sizeof(struct kbdiacr))) {
+				ret = -EFAULT;
+				break;
+			}
 		}
-		return 0;
+		break;
 	}
 	case KDGKBDIACRUC:
 	{
 		struct kbdiacrsuc __user *a = up;
 
 		if (put_user(accent_table_size, &a->kb_cnt))
-			return -EFAULT;
-		if (copy_to_user(a->kbdiacruc, accent_table, accent_table_size*sizeof(struct kbdiacruc)))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		else if (copy_to_user(a->kbdiacruc, accent_table,
+				accent_table_size*sizeof(struct kbdiacruc)))
+			ret = -EFAULT;
+		break;
 	}
 
 	case KDSKBDIACR:
@@ -616,20 +639,26 @@
 		int i;
 
 		if (!perm)
-			return -EPERM;
-		if (get_user(ct,&a->kb_cnt))
-			return -EFAULT;
-		if (ct >= MAX_DIACR)
-			return -EINVAL;
+			goto eperm;
+		if (get_user(ct,&a->kb_cnt)) {
+			ret = -EFAULT;
+			break;
+		}
+		if (ct >= MAX_DIACR) {
+			ret = -EINVAL;
+			break;
+		}
 		accent_table_size = ct;
 		for (i = 0; i < ct; i++) {
-			if (copy_from_user(&diacr, a->kbdiacr + i, sizeof(struct kbdiacr)))
-				return -EFAULT;
+			if (copy_from_user(&diacr, a->kbdiacr + i, sizeof(struct kbdiacr))) {
+				ret = -EFAULT;
+				break;
+			}
 			accent_table[i].diacr = conv_8bit_to_uni(diacr.diacr);
 			accent_table[i].base = conv_8bit_to_uni(diacr.base);
 			accent_table[i].result = conv_8bit_to_uni(diacr.result);
 		}
-		return 0;
+		break;
 	}
 
 	case KDSKBDIACRUC:
@@ -638,15 +667,19 @@
 		unsigned int ct;
 
 		if (!perm)
-			return -EPERM;
-		if (get_user(ct,&a->kb_cnt))
-			return -EFAULT;
-		if (ct >= MAX_DIACR)
-			return -EINVAL;
+			goto eperm;
+		if (get_user(ct,&a->kb_cnt)) {
+			ret = -EFAULT;
+			break;
+		}
+		if (ct >= MAX_DIACR) {
+			ret = -EINVAL;
+			break;
+		}
 		accent_table_size = ct;
 		if (copy_from_user(accent_table, a->kbdiacruc, ct*sizeof(struct kbdiacruc)))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		break;
 	}
 
 	/* the ioctls below read/set the flags usually shown in the leds */
@@ -657,26 +690,29 @@
 
 	case KDSKBLED:
 		if (!perm)
-			return -EPERM;
-		if (arg & ~0x77)
-			return -EINVAL;
+			goto eperm;
+		if (arg & ~0x77) {
+			ret = -EINVAL;
+			break;
+		}
 		kbd->ledflagstate = (arg & 7);
 		kbd->default_ledflagstate = ((arg >> 4) & 7);
 		set_leds();
-		return 0;
+		break;
 
 	/* the ioctls below only set the lights, not the functions */
 	/* for those, see KDGKBLED and KDSKBLED above */
 	case KDGETLED:
 		ucval = getledstate();
 	setchar:
-		return put_user(ucval, (char __user *)arg);
+		ret = put_user(ucval, (char __user *)arg);
+		break;
 
 	case KDSETLED:
 		if (!perm)
-		  return -EPERM;
+			goto eperm;
 		setledstate(kbd, arg);
-		return 0;
+		break;
 
 	/*
 	 * A process can indicate its willingness to accept signals
@@ -688,16 +724,17 @@
 	case KDSIGACCEPT:
 	{
 		if (!perm || !capable(CAP_KILL))
-		  return -EPERM;
+			goto eperm;
 		if (!valid_signal(arg) || arg < 1 || arg == SIGKILL)
-		  return -EINVAL;
-
-		spin_lock_irq(&vt_spawn_con.lock);
-		put_pid(vt_spawn_con.pid);
-		vt_spawn_con.pid = get_pid(task_pid(current));
-		vt_spawn_con.sig = arg;
-		spin_unlock_irq(&vt_spawn_con.lock);
-		return 0;
+			ret = -EINVAL;
+		else {
+			spin_lock_irq(&vt_spawn_con.lock);
+			put_pid(vt_spawn_con.pid);
+			vt_spawn_con.pid = get_pid(task_pid(current));
+			vt_spawn_con.sig = arg;
+			spin_unlock_irq(&vt_spawn_con.lock);
+		}
+		break;
 	}
 
 	case VT_SETMODE:
@@ -705,11 +742,15 @@
 		struct vt_mode tmp;
 
 		if (!perm)
-			return -EPERM;
-		if (copy_from_user(&tmp, up, sizeof(struct vt_mode)))
-			return -EFAULT;
-		if (tmp.mode != VT_AUTO && tmp.mode != VT_PROCESS)
-			return -EINVAL;
+			goto eperm;
+		if (copy_from_user(&tmp, up, sizeof(struct vt_mode))) {
+			ret = -EFAULT;
+			goto out;
+		}
+		if (tmp.mode != VT_AUTO && tmp.mode != VT_PROCESS) {
+			ret = -EINVAL;
+			goto out;
+		}
 		acquire_console_sem();
 		vc->vt_mode = tmp;
 		/* the frsig is ignored, so we set it to 0 */
@@ -719,7 +760,7 @@
 		/* no switch is required -- saw@shade.msu.ru */
 		vc->vt_newvt = -1;
 		release_console_sem();
-		return 0;
+		break;
 	}
 
 	case VT_GETMODE:
@@ -732,7 +773,9 @@
 		release_console_sem();
 
 		rc = copy_to_user(up, &tmp, sizeof(struct vt_mode));
-		return rc ? -EFAULT : 0;
+		if (rc)
+			ret = -EFAULT;
+		break;
 	}
 
 	/*
@@ -746,12 +789,16 @@
 		unsigned short state, mask;
 
 		if (put_user(fg_console + 1, &vtstat->v_active))
-			return -EFAULT;
-		state = 1;	/* /dev/tty0 is always open */
-		for (i = 0, mask = 2; i < MAX_NR_CONSOLES && mask; ++i, mask <<= 1)
-			if (VT_IS_IN_USE(i))
-				state |= mask;
-		return put_user(state, &vtstat->v_state);
+			ret = -EFAULT;
+		else {
+			state = 1;	/* /dev/tty0 is always open */
+			for (i = 0, mask = 2; i < MAX_NR_CONSOLES && mask;
+							++i, mask <<= 1)
+				if (VT_IS_IN_USE(i))
+					state |= mask;
+			ret = put_user(state, &vtstat->v_state);
+		}
+		break;
 	}
 
 	/*
@@ -771,27 +818,31 @@
 	 */
 	case VT_ACTIVATE:
 		if (!perm)
-			return -EPERM;
+			goto eperm;
 		if (arg == 0 || arg > MAX_NR_CONSOLES)
-			return -ENXIO;
-		arg--;
-		acquire_console_sem();
-		i = vc_allocate(arg);
-		release_console_sem();
-		if (i)
-			return i;
-		set_console(arg);
-		return 0;
+			ret =  -ENXIO;
+		else {
+			arg--;
+			acquire_console_sem();
+			ret = vc_allocate(arg);
+			release_console_sem();
+			if (ret)
+				break;
+			set_console(arg);
+		}
+		break;
 
 	/*
 	 * wait until the specified VT has been activated
 	 */
 	case VT_WAITACTIVE:
 		if (!perm)
-			return -EPERM;
+			goto eperm;
 		if (arg == 0 || arg > MAX_NR_CONSOLES)
-			return -ENXIO;
-		return vt_waitactive(arg-1);
+			ret = -ENXIO;
+		else
+			ret = vt_waitactive(arg - 1);
+		break;
 
 	/*
 	 * If a vt is under process control, the kernel will not switch to it
@@ -805,10 +856,12 @@
 	 */
 	case VT_RELDISP:
 		if (!perm)
-			return -EPERM;
-		if (vc->vt_mode.mode != VT_PROCESS)
-			return -EINVAL;
+			goto eperm;
 
+		if (vc->vt_mode.mode != VT_PROCESS) {
+			ret = -EINVAL;
+			break;
+		}
 		/*
 		 * Switching-from response
 		 */
@@ -829,10 +882,10 @@
 				int newvt;
 				newvt = vc->vt_newvt;
 				vc->vt_newvt = -1;
-				i = vc_allocate(newvt);
-				if (i) {
+				ret = vc_allocate(newvt);
+				if (ret) {
 					release_console_sem();
-					return i;
+					break;
 				}
 				/*
 				 * When we actually do the console switch,
@@ -841,31 +894,27 @@
 				 */
 				complete_change_console(vc_cons[newvt].d);
 			}
-		}
-
-		/*
-		 * Switched-to response
-		 */
-		else
-		{
+		} else {
+			/*
+			 * Switched-to response
+			 */
 			/*
 			 * If it's just an ACK, ignore it
 			 */
-			if (arg != VT_ACKACQ) {
-				release_console_sem();
-				return -EINVAL;
-			}
+			if (arg != VT_ACKACQ)
+				ret = -EINVAL;
 		}
 		release_console_sem();
-
-		return 0;
+		break;
 
 	 /*
 	  * Disallocate memory associated to VT (but leave VT1)
 	  */
 	 case VT_DISALLOCATE:
-		if (arg > MAX_NR_CONSOLES)
-			return -ENXIO;
+		if (arg > MAX_NR_CONSOLES) {
+			ret = -ENXIO;
+			break;
+		}
 		if (arg == 0) {
 		    /* deallocate all unused consoles, but leave 0 */
 			acquire_console_sem();
@@ -877,14 +926,14 @@
 			/* deallocate a single console, if possible */
 			arg--;
 			if (VT_BUSY(arg))
-				return -EBUSY;
-			if (arg) {			      /* leave 0 */
+				ret = -EBUSY;
+			else if (arg) {			      /* leave 0 */
 				acquire_console_sem();
 				vc_deallocate(arg);
 				release_console_sem();
 			}
 		}
-		return 0;
+		break;
 
 	case VT_RESIZE:
 	{
@@ -893,21 +942,21 @@
 
 		ushort ll,cc;
 		if (!perm)
-			return -EPERM;
+			goto eperm;
 		if (get_user(ll, &vtsizes->v_rows) ||
 		    get_user(cc, &vtsizes->v_cols))
-			return -EFAULT;
-
-		for (i = 0; i < MAX_NR_CONSOLES; i++) {
-			vc = vc_cons[i].d;
-
-			if (vc) {
-				vc->vc_resize_user = 1;
-				vc_lock_resize(vc_cons[i].d, cc, ll);
+			ret = -EFAULT;
+		else {
+			for (i = 0; i < MAX_NR_CONSOLES; i++) {
+				vc = vc_cons[i].d;
+
+				if (vc) {
+					vc->vc_resize_user = 1;
+					vc_lock_resize(vc_cons[i].d, cc, ll);
+				}
 			}
 		}
-
-		return 0;
+		break;
 	}
 
 	case VT_RESIZEX:
@@ -915,10 +964,13 @@
 		struct vt_consize __user *vtconsize = up;
 		ushort ll,cc,vlin,clin,vcol,ccol;
 		if (!perm)
-			return -EPERM;
+			goto eperm;
 		if (!access_ok(VERIFY_READ, vtconsize,
-				sizeof(struct vt_consize)))
-			return -EFAULT;
+				sizeof(struct vt_consize))) {
+			ret = -EFAULT;
+			break;
+		}
+		/* FIXME: Should check the copies properly */
 		__get_user(ll, &vtconsize->v_rows);
 		__get_user(cc, &vtconsize->v_cols);
 		__get_user(vlin, &vtconsize->v_vlin);
@@ -928,21 +980,28 @@
 		vlin = vlin ? vlin : vc->vc_scan_lines;
 		if (clin) {
 			if (ll) {
-				if (ll != vlin/clin)
-					return -EINVAL; /* Parameters don't add up */
+				if (ll != vlin/clin) {
+					/* Parameters don't add up */
+					ret = -EINVAL;
+					break;
+				}
 			} else 
 				ll = vlin/clin;
 		}
 		if (vcol && ccol) {
 			if (cc) {
-				if (cc != vcol/ccol)
-					return -EINVAL;
+				if (cc != vcol/ccol) {
+					ret = -EINVAL;
+					break;
+				}
 			} else
 				cc = vcol/ccol;
 		}
 
-		if (clin > 32)
-			return -EINVAL;
+		if (clin > 32) {
+			ret =  -EINVAL;
+			break;
+		}
 		    
 		for (i = 0; i < MAX_NR_CONSOLES; i++) {
 			if (!vc_cons[i].d)
@@ -956,19 +1015,20 @@
 			vc_resize(vc_cons[i].d, cc, ll);
 			release_console_sem();
 		}
-  		return 0;
+		break;
 	}
 
 	case PIO_FONT: {
 		if (!perm)
-			return -EPERM;
+			goto eperm;
 		op.op = KD_FONT_OP_SET;
 		op.flags = KD_FONT_FLAG_OLD | KD_FONT_FLAG_DONT_RECALC;	/* Compatibility */
 		op.width = 8;
 		op.height = 0;
 		op.charcount = 256;
 		op.data = up;
-		return con_font_op(vc_cons[fg_console].d, &op);
+		ret = con_font_op(vc_cons[fg_console].d, &op);
+		break;
 	}
 
 	case GIO_FONT: {
@@ -978,100 +1038,124 @@
 		op.height = 32;
 		op.charcount = 256;
 		op.data = up;
-		return con_font_op(vc_cons[fg_console].d, &op);
+		ret = con_font_op(vc_cons[fg_console].d, &op);
+		break;
 	}
 
 	case PIO_CMAP:
                 if (!perm)
-			return -EPERM;
-                return con_set_cmap(up);
+			ret = -EPERM;
+		else
+	                ret = con_set_cmap(up);
+		break;
 
 	case GIO_CMAP:
-                return con_get_cmap(up);
+                ret = con_get_cmap(up);
+		break;
 
 	case PIO_FONTX:
 	case GIO_FONTX:
-		return do_fontx_ioctl(cmd, up, perm, &op);
+		ret = do_fontx_ioctl(cmd, up, perm, &op);
+		break;
 
 	case PIO_FONTRESET:
 	{
 		if (!perm)
-			return -EPERM;
+			goto eperm;
 
 #ifdef BROKEN_GRAPHICS_PROGRAMS
 		/* With BROKEN_GRAPHICS_PROGRAMS defined, the default
 		   font is not saved. */
-		return -ENOSYS;
+		ret = -ENOSYS;
+		break;
 #else
 		{
 		op.op = KD_FONT_OP_SET_DEFAULT;
 		op.data = NULL;
-		i = con_font_op(vc_cons[fg_console].d, &op);
-		if (i)
-			return i;
+		ret = con_font_op(vc_cons[fg_console].d, &op);
+		if (ret)
+			break;
 		con_set_default_unimap(vc_cons[fg_console].d);
-		return 0;
+		break;
 		}
 #endif
 	}
 
 	case KDFONTOP: {
-		if (copy_from_user(&op, up, sizeof(op)))
-			return -EFAULT;
+		if (copy_from_user(&op, up, sizeof(op))) {
+			ret = -EFAULT;
+			break;
+		}
 		if (!perm && op.op != KD_FONT_OP_GET)
-			return -EPERM;
-		i = con_font_op(vc, &op);
-		if (i) return i;
+			goto eperm;
+		ret = con_font_op(vc, &op);
+		if (ret)
+			break;
 		if (copy_to_user(up, &op, sizeof(op)))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		break;
 	}
 
 	case PIO_SCRNMAP:
 		if (!perm)
-			return -EPERM;
-		return con_set_trans_old(up);
+			ret = -EPERM;
+		else
+			ret = con_set_trans_old(up);
+		break;
 
 	case GIO_SCRNMAP:
-		return con_get_trans_old(up);
+		ret = con_get_trans_old(up);
+		break;
 
 	case PIO_UNISCRNMAP:
 		if (!perm)
-			return -EPERM;
-		return con_set_trans_new(up);
+			ret = -EPERM;
+		else
+			ret = con_set_trans_new(up);
+		break;
 
 	case GIO_UNISCRNMAP:
-		return con_get_trans_new(up);
+		ret = con_get_trans_new(up);
+		break;
 
 	case PIO_UNIMAPCLR:
 	      { struct unimapinit ui;
 		if (!perm)
-			return -EPERM;
-		i = copy_from_user(&ui, up, sizeof(struct unimapinit));
-		if (i) return -EFAULT;
-		con_clear_unimap(vc, &ui);
-		return 0;
+			goto eperm;
+		ret = copy_from_user(&ui, up, sizeof(struct unimapinit));
+		if (!ret)
+			con_clear_unimap(vc, &ui);
+		break;
 	      }
 
 	case PIO_UNIMAP:
 	case GIO_UNIMAP:
-		return do_unimap_ioctl(cmd, up, perm, vc);
+		ret = do_unimap_ioctl(cmd, up, perm, vc);
+		break;
 
 	case VT_LOCKSWITCH:
 		if (!capable(CAP_SYS_TTY_CONFIG))
-		   return -EPERM;
+			goto eperm;
 		vt_dont_switch = 1;
-		return 0;
+		break;
 	case VT_UNLOCKSWITCH:
 		if (!capable(CAP_SYS_TTY_CONFIG))
-		   return -EPERM;
+			goto eperm;
 		vt_dont_switch = 0;
-		return 0;
+		break;
 	case VT_GETHIFONTMASK:
-		return put_user(vc->vc_hi_font_mask, (unsigned short __user *)arg);
+		ret = put_user(vc->vc_hi_font_mask, 
+					(unsigned short __user *)arg);
+		break;
 	default:
-		return -ENOIOCTLCMD;
+		ret = -ENOIOCTLCMD;
 	}
+out:
+	unlock_kernel();
+	return ret;
+eperm:
+	ret = -EPERM;
+	goto out;
 }
 
 /*
