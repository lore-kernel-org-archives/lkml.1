Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZK3BKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZK3BKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 20:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZK3BKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 20:10:44 -0500
Received: from mail-px0-f188.google.com ([209.85.216.188]:44449 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbZK3BKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 20:10:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cvy0OZxZOgKcWh9vBSiJacW9uNv45AxgpdlKXpWyxZYvdJDv5sMD3WNN/mwfgqTu8p
         YCrwjVpvhkjQh8YOl9qqeq+SZiyfxbWGQfVzl8sNb8LxzYqcU1Oa0egAUsaYskPj6omS
         4LisW0oU+CzcAMxLes+DSnXovxc0JEwa+EC2I=
Date: Sun, 29 Nov 2009 17:10:46 -0800
From: 640E9920 <640e9920@gmail.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, perex@perex.cz, tiwai@suse.de
Subject: [RFC]PM_QOS api update to use handles 5/5 (pcm updates)
Message-ID: <20091130011045.GE4732@mgross-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d8Lz2Tf5e5STOWUP"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d8Lz2Tf5e5STOWUP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is the patch to update sound pcm's dependencies on the pmqos api
that was changed in the first patch in this series.

--mgross

Signed-off-by: mark gross <mgross@linux.intel.com>



---
 include/sound/pcm.h     |    3 ++-
 sound/core/pcm.c        |    3 ---
 sound/core/pcm_native.c |   12 ++++++------
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index de6d981..91daac3 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -29,6 +29,7 @@
 #include <linux/poll.h>
 #include <linux/mm.h>
 #include <linux/bitops.h>
+#include <linux/pm_qos_params.h>
=20
 #define snd_pcm_substream_chip(substream) ((substream)->private_data)
 #define snd_pcm_chip(pcm) ((pcm)->private_data)
@@ -355,7 +356,7 @@ struct snd_pcm_substream {
 	int number;
 	char name[32];			/* substream name */
 	int stream;			/* stream (direction) */
-	char latency_id[20];		/* latency identifier */
+	struct pm_qos_request_list *latency_pm_qos_req; /* pm_qos latency request=
 */
 	size_t buffer_bytes_max;	/* limit ring buffer size */
 	struct snd_dma_buffer dma_buffer;
 	unsigned int dma_buf_id;
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index c69c60b..6faf4b5 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -647,9 +647,6 @@ int snd_pcm_new_stream(struct snd_pcm *pcm, int stream,=
 int substream_count)
 		substream->number =3D idx;
 		substream->stream =3D stream;
 		sprintf(substream->name, "subdevice #%i", idx);
-		snprintf(substream->latency_id, sizeof(substream->latency_id),
-			 "ALSA-PCM%d-%d%c%d", pcm->card->number, pcm->device,
-			 (stream ? 'c' : 'p'), idx);
 		substream->buffer_bytes_max =3D UINT_MAX;
 		if (prev =3D=3D NULL)
 			pstr->substream =3D substream;
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index ab73edf..e52eeec 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -447,11 +447,12 @@ static int snd_pcm_hw_params(struct snd_pcm_substream=
 *substream,
 	snd_pcm_timer_resolution_change(substream);
 	runtime->status->state =3D SNDRV_PCM_STATE_SETUP;
=20
-	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY,
-				substream->latency_id);
+	if (substream->latency_pm_qos_req)
+		pm_qos_remove_request(substream->latency_pm_qos_req);
+
 	if ((usecs =3D period_to_usecs(runtime)) >=3D 0)
-		pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY,
-					substream->latency_id, usecs);
+		substream->latency_pm_qos_req =3D pm_qos_add_request(
+					PM_QOS_CPU_DMA_LATENCY, usecs);
 	return 0;
  _error:
 	/* hardware might be unuseable from this time,
@@ -506,8 +507,7 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *su=
bstream)
 	if (substream->ops->hw_free)
 		result =3D substream->ops->hw_free(substream);
 	runtime->status->state =3D SNDRV_PCM_STATE_OPEN;
-	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY,
-		substream->latency_id);
+	pm_qos_remove_request(substream->latency_pm_qos_req);
 	return result;
 }
=20
--=20
1.6.3.3


--d8Lz2Tf5e5STOWUP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksTG5UACgkQhK5OsmQOmSDwsgCfZJj4AdOe6mBhiZ37C8r8YSNM
f98An0gqnZzTdnh1BXhbDJDIlR035PAR
=ZAOP
-----END PGP SIGNATURE-----

--d8Lz2Tf5e5STOWUP--
